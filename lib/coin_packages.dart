/// Harga resmi paket CUAN PARTY (Rupiah).
/// Coin hanya boleh dikreditkan setelah pembayaran diverifikasi backend.
class CoinPackages {
  static const List<Map<String, String>> options = [
    {'coins': '250.000', 'amount': '250000', 'price': 'Rp 5.000'},
    {'coins': '500.000', 'amount': '500000', 'price': 'Rp 10.000', 'tag': 'Favorit'},
    {'coins': '1.025.000', 'amount': '1025000', 'price': 'Rp 20.000', 'tag': '+2,5%'},
    {'coins': '2.625.000', 'amount': '2625000', 'price': 'Rp 50.000', 'tag': '+5%'},
    {'coins': '5.375.000', 'amount': '5375000', 'price': 'Rp 100.000', 'tag': '+7,5%'},
    {'coins': '13.750.000', 'amount': '13750000', 'price': 'Rp 250.000', 'tag': '+10%'},
    {'coins': '28.125.000', 'amount': '28125000', 'price': 'Rp 500.000', 'tag': '+12,5%'},
    {'coins': '57.500.000', 'amount': '57500000', 'price': 'Rp 1.000.000', 'tag': '+15%'},
  ];

  static Map<String, String>? byAmount(int coins) {
    for (final item in options) {
      if (int.parse(item['amount']!) == coins) return item;
    }
    return null;
  }
}
