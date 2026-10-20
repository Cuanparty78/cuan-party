#!/usr/bin/env python3
"""Load verified server transaction history in Wallet > Transaction tab."""
from pathlib import Path

path = Path('lib/luxury_app.dart')
s = path.read_text(encoding='utf-8')
old_state = '''class _WalletPageState extends State<WalletPage> {
  int _tab = 0;
  final _exchangeController = TextEditingController();'''
new_state = '''class _WalletPageState extends State<WalletPage> {
  int _tab = 0;
  late Future<List<Map<String, dynamic>>> _historyFuture;
  final _exchangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _historyFuture = EconomyService().getWalletHistory();
  }

  void _refreshWalletHistory() {
    setState(() {
      _historyFuture = EconomyService().getWalletHistory();
    });
  }

  String _walletHistoryLabel(Map<String, dynamic> record) {
    final kind = record['type']?.toString() ?? '';
    final incoming = record['direction'] == 'in';
    final amount = record['amount'] is num ? (record['amount'] as num).toInt() : 0;
    final heading = kind == 'ownerIssue'
        ? 'Isi Coin dari Owner'
        : kind == 'sellerTransfer'
            ? (incoming ? 'Isi Coin dari Seller' : 'Transfer ke User')
            : kind == 'roomGift' ? 'Kirim Gift' : 'Transaksi Coin';
    final millis = record['createdAt'] is num ? (record['createdAt'] as num).toInt() : 0;
    final date = millis > 0 ? DateTime.fromMillisecondsSinceEpoch(millis).toLocal() : null;
    final when = date == null ? '' :
        ' • ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$heading\\n${incoming ? '+' : '-'}${_formatCoins(amount)} Coin$when';
  }'''
assert s.count(old_state) == 1, 'Wallet State not found'
s = s.replace(old_state, new_state, 1)
start = s.index('  Widget _transactionTab() {', s.index('class _WalletPageState extends State<WalletPage>'))
end = s.index('  Widget _walletHistoryRow(String row) {', start)
s = s[:start] + '''  Widget _transactionTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: walletTransactions,
          builder: (context, localRows, _) {
            final verified = snapshot.data ?? <Map<String, dynamic>>[];
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    onPressed: _refreshWalletHistory,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Perbarui riwayat transaksi'),
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ))
                  else if (snapshot.hasError) ...[
                    const Text('Riwayat dari server belum bisa dimuat.',
                        style: TextStyle(color: Color(0xFF9C382D), fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(snapshot.error.toString(),
                        style: const TextStyle(color: Color(0xFF6F5A43), fontSize: 12)),
                  ] else if (verified.isEmpty && localRows.isEmpty)
                    _emptyWallet('Belum ada transaksi')
                  else ...[
                    if (verified.isNotEmpty) ...[
                      const Text('Transaksi terverifikasi server', style:
                          TextStyle(color: Color(0xFF70451E), fontWeight: FontWeight.w800)),
                      const SizedBox(height: 9),
                      ...verified.map((row) => _walletHistoryRow(_walletHistoryLabel(row))),
                    ],
                    if (localRows.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text('Aktivitas sesi ini (belum diverifikasi)', style:
                          TextStyle(color: Color(0xFF70451E), fontWeight: FontWeight.w700)),
                      const SizedBox(height: 9),
                      ...localRows.map(_walletHistoryRow),
                    ],
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

''' + s[end:]
path.write_text(s, encoding='utf-8')
print('Wallet Transaction reads verified owner/seller coin history.')
