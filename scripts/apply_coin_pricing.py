#!/usr/bin/env python3
"""Patch current GitHub checkout without reformatting 7 MB UI file."""
from pathlib import Path

p = Path('lib/luxury_app.dart')
s = p.read_text(encoding='utf-8')
initial = s
assert "import 'coin_packages.dart';" not in s, 'Coin pricing already applied'
anchor = "import 'package:flutter/material.dart';"
assert anchor in s, 'Flutter import changed'
s = s.replace(anchor, anchor + "\nimport 'coin_packages.dart';", 1)

start = s.index('  final List<Map<String, String>> _packages = const [')
end = s.index('  @override\n  void dispose()', start)
s = s[:start] + '  final List<Map<String, String>> _packages = CoinPackages.options;\n\n' + s[end:]

start = s.index('  void _confirmTopUp(int amount, String price) {')
end = s.index('  Widget _transactionTab()', start)
dialog = '''  void _confirmTopUp(int amount, String price) {
    // A paid wallet can never be credited by client-side confirmation.
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF3),
        title: const Text('Paket Coin CUAN PARTY',
          style: TextStyle(color: Color(0xFF70451E), fontWeight: FontWeight.w800)),
        content: Text(
          'Jumlah: ${_formatCoins(amount)} Coin\\nHarga: $price\\n\\n'
          'Pembayaran belum diaktifkan. Coin baru ditambahkan '
          'setelah pembayaran diverifikasi oleh server.',
          style: const TextStyle(color: Color(0xFF6F5A43), height: 1.4),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB87912)),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

'''
s = s[:start] + dialog + s[end:]

fake_recharge = '''void _recharge(int coins) {
  _addCoins(coins);
  _addWalletTransaction('Isi Saldo +${_formatCoins(coins)} Coin');
}

'''
assert fake_recharge in s, 'Old fake recharge code changed'
s = s.replace(fake_recharge, '', 1)

gift_error = "'Layanan gift belum tersedia.'"
assert gift_error in s, 'Expected missing gift backend state changed'
s = s.replace(gift_error, "'Pengiriman gift membutuhkan Firebase Cloud Functions aktif. Coin tidak dipotong.'", 1)
s = s.replace("Text('Aktif', style: TextStyle(color: Color(0xFF8A6231), fontSize: 11, fontWeight: FontWeight.w700))",
              "Text('Harga Resmi', style: TextStyle(color: Color(0xFF8A6231), fontSize: 11, fontWeight: FontWeight.w700))", 1)
assert '_recharge(' not in s
assert 'Mode  akan menambahkan' not in s
assert 'CoinPackages.options' in s
assert len(initial) - len(s) < 5000, 'Unexpected large change'
p.write_text(s, encoding='utf-8')
print('Price packages integrated; fake recharge disabled; gift dependency clarified.')
