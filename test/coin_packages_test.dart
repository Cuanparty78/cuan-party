import 'package:flutter_test/flutter_test.dart';
import 'package:cuan_party/coin_packages.dart';

void main() {
  test('Official Indonesian coin prices and bonus tiers', () {
    const amounts = [250000, 500000, 1025000, 2625000, 5375000, 13750000, 28125000, 57500000];
    const prices = ['Rp 5.000', 'Rp 10.000', 'Rp 20.000', 'Rp 50.000', 'Rp 100.000', 'Rp 250.000', 'Rp 500.000', 'Rp 1.000.000'];
    expect(CoinPackages.options.length, 8);
    for (var i = 0; i < amounts.length; i++) {
      expect(CoinPackages.byAmount(amounts[i])?['price'], prices[i]);
    }
    expect(CoinPackages.byAmount(42), isNull);
  });
}
