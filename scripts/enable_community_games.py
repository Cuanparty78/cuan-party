#!/usr/bin/env python3
from pathlib import Path
p=Path("lib/luxury_app.dart")
s=p.read_text()
assert "import 'party_minigames.dart';" not in s
s=s.replace("import 'coin_packages.dart';","import 'coin_packages.dart';\nimport 'party_minigames.dart';",1)
old="""    const games = [
      ('Ludo', Icons.sports_esports_rounded),
      ('Monster Crush', Icons.extension_rounded),
      ('UNO', Icons.style_rounded),
      ('Carrom', Icons.circle_rounded),
      ('Domino', Icons.grid_view_rounded),
      ('Jackaroo', Icons.groups_rounded),
    ];"""
new="""    const games = [
      ('XO Party', Icons.grid_3x3_rounded),
      ('Dadu Party', Icons.casino_rounded),
      ('Memory Match', Icons.extension_rounded),
    ];"""
assert s.count(old)==1
s=s.replace(old,new,1)
old="MaterialPageRoute(builder: (_) => GameHubPage(initialGame: title)),"
new="MaterialPageRoute(builder: (_) => PartyMiniGamesPage(initialGame: title)),"
assert s.count(old)==1
s=s.replace(old,new,1)
start=s.index("    final games = [",s.index("class GameHubPage extends StatelessWidget"))
end=s.index("    return Scaffold(",start)
s=s[:start]+"""    final games = [
      ('XO Party', Icons.grid_3x3_rounded),
      ('Dadu Party', Icons.casino_rounded),
      ('Memory Match', Icons.extension_rounded),
      ('SLOT KINGDOM', Icons.casino_rounded),
    ];
"""+s[end:]
old="                    _showMessage(context, '${game.$1} akan terhubung ke modul game.');"
new="""                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => PartyMiniGamesPage(initialGame: game.$1)));"""
assert s.count(old)==1
s=s.replace(old,new,1)
old="                child: Icon(icon, color: const Color(0xFFEED7FF), size: 38),"
new="""                child: Center(child: Container(
                  width: 63, height: 63,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(colors: [Color(0xFFFFE5A0), Color(0xFF9A5F24), Color(0xFF3B1B6C)]),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFD66B), width: 2),
                    boxShadow: [BoxShadow(color: const Color(0xFFFFD66B).withOpacity(.28), blurRadius: 12)],
                  ),
                  child: Center(child: Icon(icon, color: Colors.white, size: 37)),
                )),"""
assert s.count(old)==1
s=s.replace(old,new,1)
p.write_text(s)
print("Games and gift card visuals patched")
