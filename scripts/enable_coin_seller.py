#!/usr/bin/env python3
"""Wire Coin Seller Center to the existing luxury Wallet and Profile UI."""
from pathlib import Path
p=Path("lib/luxury_app.dart")
s=p.read_text(encoding="utf-8")
assert "import 'coin_seller_page.dart';" not in s
s=s.replace("import 'coin_packages.dart';",
  "import 'coin_packages.dart';\nimport 'coin_seller_page.dart';", 1)
old="""           _goldIconButton(Icons.help_outline_rounded, () {
             _showMessage(context, 'Pilih paket Coin untuk menambah saldo.');
           }),"""
new="""           _goldIconButton(Icons.storefront_rounded, () {
             Navigator.push(context, MaterialPageRoute(
               builder: (_) => const CoinSellerPage()));
           }),"""
assert s.count(old)==1, "Wallet top button changed"
s=s.replace(old,new,1)
old="""              _ProfileRow(
                'Customer Service Room',"""
new="""              _ProfileRow(
                'Coin Seller',
                Icons.storefront_rounded,
                () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const CoinSellerPage())),
              ),

              _ProfileRow(
                'Customer Service Room',"""
assert s.count(old)==1, "Profile menu structure changed"
s=s.replace(old,new,1)
p.write_text(s,encoding="utf-8")
print("Coin Seller entry added to Wallet and Profile.")
