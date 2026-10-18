#!/usr/bin/env python3
"""CUAN PARTY stabilization: never mint or deduct coins in a client-only UI.
Idempotent text patch against the Slot-kingdom Flutter baseline.
Fails closed on unexpected source changes.
"""
from pathlib import Path

path = Path("lib/luxury_app.dart")
src = path.read_text(encoding="utf-8")
if "_recharge(amount)" not in src and "EconomyService().claimVipCheckin(" in src and "Top Up belum tersedia. Saldo tidak berubah." in src:
    print("CUAN PARTY client economy fixes already applied.")
    raise SystemExit(0)
changes = []

def exact(old: str, new: str, reason: str):
    global src
    n = src.count(old)
    if n != 1:
        raise SystemExit(f"STOP: {reason}: expected 1 match; got {n}")
    src = src.replace(old, new, 1)
    changes.append(reason)

def change_region(first: str, last: str, transform, reason: str):
    global src
    a = src.find(first)
    b = src.find(last, a + len(first))
    if a < 0 or b < 0:
        raise SystemExit(f"STOP: missing region {reason}")
    before = src[a:b]
    after = transform(before)
    if before == after:
        raise SystemExit(f"STOP: unchanged region {reason}")
    src = src[:a] + after + src[b:]
    changes.append(reason)

exact(
    """void _recharge(int coins) {
  _addCoins(coins);
  _addWalletTransaction('Isi Saldo +${_formatCoins(coins)} Coin');
}

""", "", "remove local top-up minting")

def payment(p):
    a = p.index("        content: Text(")
    b = p.index("        actions: [", a)
    p = p[:a] + """        content: Text(
          'Paket ${_formatCoins(amount)} Coin • $price. Pembayaran belum terhubung. Saldo hanya bertambah setelah diverifikasi oleh server.',
          style: const TextStyle(color: Color(0xFF6F5A43), height: 1.4),
        ),
""" + p[b:]
    old = """            onPressed: () {
              _recharge(amount);
              Navigator.pop(dialogContext);
              setState(() {});
              _showMessage(context, '+${_formatCoins(amount)} Coin berhasil ditambahkan.');
            },
            child: const Text('Top Up'),"""
    new = """            onPressed: () {
              Navigator.pop(dialogContext);
              _showMessage(context, 'Top Up belum tersedia. Saldo tidak berubah.');
            },
            child: const Text('Belum Tersedia'),"""
    if old not in p: raise SystemExit("STOP: payment button not found")
    return p.replace(old, new)
change_region("  void _confirmTopUp(int amount, String price) {", "  Widget _transactionTab() {",
              payment, "block fake payment confirmation")

def exchange(p):
    p = p.replace("  final controller = TextEditingController();",
                  "  final controller = TextEditingController();\n  bool exchanging = false;", 1)
    old = """              onPressed: () {
                final amount = int.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;"""
    new = """              onPressed: exchanging ? null : () async {
                final amount = int.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;"""
    if old not in p: raise SystemExit("STOP: exchange handler missing")
    p = p.replace(old, new, 1)
    old = """                final coins = (amount * 70) ~/ 100;
                _setDiamonds(diamondBalance.value - amount);
                _addCoins(coins);
                _addWalletTransaction(
                  '-${_formatCoins(amount)} Diamond → +${_formatCoins(coins)} Coin',
                );
                Navigator.pop(dialogContext);
                _showMessage(
                  context,
                  'Penukaran berhasil: -${_formatCoins(amount)} Diamond, +${_formatCoins(coins)} Coin.',
                );"""
    new = """                setState(() => exchanging = true);
                try {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) throw StateError('LOGIN_REQUIRED');
                  final result = await EconomyService().exchangeDiamondToCoin(
                    diamond: amount,
                    transactionId: 'exchange_${uid}_${DateTime.now().microsecondsSinceEpoch}',
                  );
                  final newCoin = result['coin'];
                  final newDiamond = result['diamond'];
                  if (newCoin is num) coinBalance.value = newCoin.toInt();
                  if (newDiamond is num) diamondBalance.value = newDiamond.toInt();
                  _addWalletTransaction('Exchange -${_formatCoins(amount)} Diamond');
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                  if (context.mounted) _showMessage(context, 'Exchange berhasil di server.');
                } catch (error) {
                  if (dialogContext.mounted) setState(() => exchanging = false);
                  if (context.mounted) _showMessage(context,
                    error is FirebaseFunctionsException
                      ? (error.message ?? 'Exchange gagal.')
                      : 'Exchange gagal. Coba kembali.');
                }"""
    if old not in p: raise SystemExit("STOP: fake exchange block missing")
    p = p.replace(old, new, 1)
    p = p.replace("child: const Text('Tukar Diamond'),",
                  "child: Text(exchanging ? 'Memproses...' : 'Tukar Diamond'),", 1)
    return p
change_region("void _showExchange(BuildContext context) {", "int _profileLevelFromData(",
              exchange, "replace fake exchange with backend")

def checkin(p):
    if p.count("final today = DateTime.now();") != 2:
        raise SystemExit("STOP: VIP check-in date anchors changed")
    p = p.replace("final today = DateTime.now();",
                  "final today = DateTime.now().toUtc().add(const Duration(hours: 7));")
    start = p.index("  Future<void> _checkIn() async {")
    end = p.index("\n  }\n}", start) + len("\n  }")
    method = """  Future<void> _checkIn() async {
    if (_loading || _claimed || _ownedVip <= 0) return;
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw StateError('LOGIN_REQUIRED');
      final today = DateTime.now().toUtc().add(const Duration(hours: 7));
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final result = await EconomyService().claimVipCheckin(
        dateKey: dateKey,
        transactionId: 'vipcheckin_${uid}_${DateTime.now().microsecondsSinceEpoch}',
      );
      if (!mounted) return;
      final serverCoin = result['coin'];
      if (serverCoin is num) coinBalance.value = serverCoin.toInt();
      setState(() { _claimed = true; _loading = false; });
      final reward = result['reward'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check-in berhasil! +${_formatCoins(reward is num ? reward.toInt() : _reward)} Coin'),
      ));
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error is FirebaseFunctionsException
          ? (error.message ?? 'Check-in gagal.')
          : 'Check-in gagal. Coba lagi.'),
      ));
    }
  }"""
    return p[:start] + method + p[end:]
change_region("class _VipDailyCheckinState extends State<_VipDailyCheckin> {",
              "class _SvipStatusCard extends StatefulWidget {", checkin,
              "move VIP check-in to trusted function")

exact(
    """  void _buyStoreItem(BuildContext context, String item, int price) {
    if (coinBalance.value < price) {
      _showMessage(context, 'Coin tidak cukup. Butuh ${_formatCoins(price)} Coin.');
      return;
    }
    _setCoins(coinBalance.value - price);
    _addWalletTransaction('Beli $item -${_formatCoins(price)} Coin');
    _showMessage(context, '$item berhasil dibeli dan masuk Bag.');
  }""",
    """  void _buyStoreItem(BuildContext context, String item, int price) {
    _showMessage(context, 'Pembelian $item belum tersedia. Saldo tidak berubah.');
  }""",
    "disable client-only store charge",
)

assert "_recharge(amount)" not in src
assert "vipLastCheckin': todayKey" not in src
assert "_addCoins(coins);" not in src
assert "EconomyService().claimVipCheckin(" in src
assert "EconomyService().exchangeDiamondToCoin(" in src
path.write_text(src, encoding="utf-8")
print("Applied CUAN PARTY economy fixes:", ", ".join(changes))
