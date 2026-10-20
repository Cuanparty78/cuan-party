import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Coin Seller stock is server-owned, separate from the user's spendable wallet.
class CoinSellerPage extends StatefulWidget {
  const CoinSellerPage({super.key});
  @override
  State<CoinSellerPage> createState() => _CoinSellerPageState();
}

class _CoinSellerPageState extends State<CoinSellerPage> {
  static const _base = 'https://cuan-workspace-api-production.up.railway.app';
  static const _dark = Color(0xFF2B173A);
  static const _gold = Color(0xFFD4A850);
  static const _cream = Color(0xFFFFF8E8);
  final _target = TextEditingController();
  final _amount = TextEditingController();
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _history = [];
  String _error = '';
  String _message = '';
  bool _busy = false, _loading = true;

  @override
  void initState() { super.initState(); _refresh(); }

  @override
  void dispose() {
    _target.dispose(); _amount.dispose();
    super.dispose();
  }

  String _format(int value) => value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');

  Future<Map<String, dynamic>> _call(String path, [Map<String, dynamic>? data]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Masuk ke akun CUAN PARTY dahulu.');
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) throw Exception('Login ulang diperlukan.');
    final uri = Uri.parse('$_base$path');
    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      if (data != null) 'Content-Type': 'application/json',
    };
    final response = await (data == null
      ? http.get(uri, headers: headers)
      : http.post(uri, headers: headers, body: jsonEncode(data)))
      .timeout(const Duration(seconds: 25));
    final body = jsonDecode(response.body);
    if (body is! Map) throw Exception('Respons server tidak valid.');
    final result = Map<String, dynamic>.from(body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(result['error']?.toString() ?? 'Permintaan gagal.');
    }
    return result;
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = ''; });
    try {
      final account = await _call('/api/seller/me');
      List<Map<String, dynamic>> items = [];
      if (account['active'] == true) {
        final ledger = await _call('/api/seller/history');
        items = (ledger['items'] as List? ?? [])
          .whereType<Map>().map((v) => Map<String, dynamic>.from(v)).toList();
      }
      if (mounted) setState(() { _profile = account; _history = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _send({required bool toSelf}) async {
    final myId = (_profile?['cuanId'] ?? '').toString().trim();
    final destination = toSelf ? myId : _target.text.trim();
    final amount = int.tryParse(_amount.text.trim().replaceAll('.', ''));
    if (!RegExp(r'^\d{6,13}$').hasMatch(destination)) {
      _show('ID akun tujuan tidak valid.');
      return;
    }
    if (amount == null || amount < 1 || amount > 1000000000) {
      _show('Masukkan jumlah Coin 1 sampai 1.000.000.000.');
      return;
    }
    if ((_profile?['active'] ?? false) != true) {
      _show('Akun belum berstatus Coin Seller aktif.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi kirim Coin'),
        content: Text('Kirim ${_format(amount)} Coin dari STOK Seller ke ID $destination?'
          '\n\nStok Seller berkurang dan dompet penerima bertambah.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Kirim')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() { _busy = true; _message = 'Memproses transaksi...'; });
    try {
      // A unique idempotency key; never retry automatically after a timeout.
      final transactionId = '${DateTime.now().microsecondsSinceEpoch}-${FirebaseAuth.instance.currentUser!.uid.substring(0, 8)}';
      final result = await _call('/api/seller/send', {
        'targetId': destination,
        'amount': amount,
        'transactionId': transactionId,
      });
      if (!mounted) return;
      setState(() {
        _message = '✅ Berhasil: ${_format(amount)} Coin ke ID $destination. Sisa stok: ${_format((result['stockCoin'] as num).toInt())}';
        _amount.clear();
      });
      await _refresh();
    } catch (e) {
      if (mounted) setState(() {
        _message = '❌ $e. Periksa saldo/riwayat sebelum mengulangi.';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _card(Widget child) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _gold, width: 1),
      boxShadow: [BoxShadow(color: _gold.withOpacity(.10), blurRadius: 14)],
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final active = _profile?['active'] == true;
    final stock = (_profile?['stockCoin'] as num?)?.toInt() ?? 0;
    final wallet = (_profile?['walletCoin'] as num?)?.toInt() ?? 0;
    final ownId = (_profile?['cuanId'] ?? '-').toString();
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text('👑 COIN SELLER', style: TextStyle(fontWeight: FontWeight.w900)),
        foregroundColor: _gold,
        backgroundColor: _dark,
        actions: [IconButton(onPressed: _busy ? null : _refresh, icon: const Icon(Icons.refresh))],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator())
        : ListView(padding: const EdgeInsets.all(17), children: [
          if (_error.isNotEmpty) _card(Text('Koneksi server: $_error')),
          if (!active) _card(const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Coin Seller belum aktif', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
              SizedBox(height: 8),
              Text('Pemilik dapat mengaktifkan akun lewat Panel Owner → Aktifkan JEP sebagai Coin Seller, atau melalui menu Akun Coin Seller.'),
              SizedBox(height: 8),
              Text('Hanya Panel Owner yang boleh membuat / mengisi stok Coin Seller.'),
            ],
          )),
          if (active) ...[
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✅ SELLER AKTIF', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: _dark)),
              Text('CUAN ID $ownId', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),
              const Text('STOK COIN SELLER', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(_format(stock), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFFA87820))),
              const SizedBox(height: 7),
              Text('Dompet Pribadi: ${_format(wallet)} Coin'),
              const SizedBox(height: 8),
              const Text('Stok hanya bisa diisi oleh Owner dari panel. Mengirim Coin akan mengurangi stok ini, bukan Coin pribadi.', style: TextStyle(fontSize: 12)),
            ])),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('TRANSFER COIN SELLER', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: _dark)),
              const SizedBox(height: 14),
              TextField(controller: _target, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID User Penerima', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _amount, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Coin', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              FilledButton.icon(
                onPressed: _busy ? null : () => _send(toSelf: false),
                icon: const Icon(Icons.send),
                label: const Text('Kirim ke User'),
                style: FilledButton.styleFrom(backgroundColor: _dark, foregroundColor: Colors.white),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _send(toSelf: true),
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('Isi Dompet Saya Sendiri'),
                style: OutlinedButton.styleFrom(foregroundColor: _dark),
              ),
              if (_message.isNotEmpty) Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_message, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ])),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('RIWAYAT STOK SELLER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _dark)),
              if (_history.isEmpty) const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text('Belum ada transaksi stok seller.'),
              ),
              for (final row in _history) ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(row['direction'] == 'in' ? Icons.add_circle : Icons.outbond, color: _gold),
                title: Text(row['direction'] == 'in' ? 'Isi Stok dari Panel' : 'Kirim Coin ke ID ${row['targetCuanId'] ?? '-'}'),
                subtitle: Text(_dateText(row['createdAt'])),
                trailing: Text('${row['direction'] == 'in' ? '+' : '-'}${_format((row['amount'] as num?)?.toInt() ?? 0)}',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: _dark)),
              ),
            ])),
          ],
        ]),
    );
  }

  String _dateText(dynamic value) {
    final n = (value is num ? value : 0).toInt();
    if (n <= 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(n).toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
