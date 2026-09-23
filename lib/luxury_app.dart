
import 'package:flutter/material.dart';

void main() => runApp(const CuanPartyApp());

class CuanPartyApp extends StatelessWidget {
  const CuanPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cuan Party',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _C.bg,
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: _C.gold),
      ),
      home: const MainShell(),
    );
  }
}

class _C {
  static const bg = Color(0xFFF8F1E6);
  static const surface = Color(0xFFFFFBF4);
  static const surface2 = Color(0xFFF3E7D4);
  static const brown = Color(0xFF5B3A20);
  static const brown2 = Color(0xFF7B5632);
  static const gold = Color(0xFFC89B4A);
  static const gold2 = Color(0xFFE8C979);
  static const line = Color(0xFFE5D6BE);
  static const text = Color(0xFF3E2B1D);
  static const muted = Color(0xFF8D7A68);
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [
    HomePage(),
    RoomPage(),
    FamilyPage(),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: _BottomNav(
        index: index,
        onChanged: (v) => setState(() => index = v),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.forum_rounded, 'Room'),
      (Icons.groups_rounded, 'Family'),
      (Icons.account_balance_wallet_rounded, 'Wallet'),
      (Icons.person_rounded, 'Profile'),
    ];
    return NavigationBar(
      height: 72,
      backgroundColor: _C.surface,
      indicatorColor: _C.surface2,
      selectedIndex: index,
      onDestinationSelected: onChanged,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.$1, color: _C.muted),
            selectedIcon: Icon(item.$1, color: _C.brown),
            label: item.$2,
          ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onSearch;
  final List<Widget> actions;
  const _TopBar({required this.title, this.onSearch, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _C.text,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (onSearch != null)
            IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, color: _C.brown),
            ),
          ...actions,
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final String hint;
  const _SearchBox({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _C.gold, size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _C.muted, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionTitle(this.title, {this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: _C.text,
              ),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See all', style: TextStyle(color: _C.brown2)),
            ),
        ],
      ),
    );
  }
}

class _LuxuryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const _LuxuryCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
    return onTap == null
        ? card
        : InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: card,
          );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: _C.gold2,
                  child: Icon(Icons.person, color: _C.brown, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good evening 👋',
                          style: TextStyle(color: _C.muted, fontSize: 13)),
                      SizedBox(height: 3),
                      Text('CUAN PARTY',
                          style: TextStyle(
                              color: _C.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                _CircleAction(icon: Icons.search_rounded, onTap: () {}),
                const SizedBox(width: 8),
                _CircleAction(icon: Icons.notifications_none_rounded, onTap: () {}),
              ],
            ),
          ),
          const _SearchBox(hint: 'Search rooms, people or family'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 165,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [_C.brown, Color(0xFF9D6B32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: _C.gold2),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REAL VOICES',
                            style: TextStyle(
                                color: _C.gold2,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2)),
                        SizedBox(height: 8),
                        Text('Find your people',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Discover people, rooms and moments.',
                            style: TextStyle(
                                color: Color(0xFFEAD9C0), fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    width: 92,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.graphic_eq_rounded,
                        size: 52, color: _C.gold2),
                  ),
                ],
              ),
            ),
          ),
          const _SectionTitle('Discover'),
          _HomeLink(
            icon: Icons.groups_rounded,
            title: 'Family Rank',
            subtitle: 'See active families',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingPage(type: 'Family'))),
          ),
          _HomeLink(
            icon: Icons.people_alt_rounded,
            title: 'CP Rank',
            subtitle: 'See community ranking',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingPage(type: 'CP'))),
          ),
          _HomeLink(
            icon: Icons.emoji_events_rounded,
            title: 'User Rank',
            subtitle: 'See top users',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingPage(type: 'User'))),
          ),
          _HomeLink(
            icon: Icons.calendar_month_rounded,
            title: 'Events',
            subtitle: 'Explore current events',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EventsPage())),
          ),
          const _SectionTitle('Games'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _GameTile('Lucky Dice', Icons.casino_rounded),
                _GameTile('Card Battle', Icons.style_rounded),
                _GameTile('Spin Wheel', Icons.settings_backup_restore_rounded),
                _GameTile('Quiz Room', Icons.help_outline_rounded),
                _GameTile('Guess Song', Icons.headphones_rounded),
                _GameTile('More Games', Icons.sports_esports_rounded, soon: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _C.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: _C.brown),
        ),
      ),
    );
  }
}

class _HomeLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _HomeLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: _LuxuryCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _C.surface2,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: _C.brown, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: _C.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: _C.muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _C.muted),
          ],
        ),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool soon;
  const _GameTile(this.title, this.icon, {this.soon = false});

  @override
  Widget build(BuildContext context) {
    return _LuxuryCard(
      onTap: () => _showMessage(context, soon ? 'Coming soon' : '$title akan dibuka dari Game Hub.'),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _C.gold, size: 38),
          const SizedBox(height: 10),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: _C.text, fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 4),
          Text(soon ? 'Coming Soon' : 'Play Now',
              style: const TextStyle(color: _C.brown2, fontSize: 12)),
        ],
      ),
    );
  }
}

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      ('Chill Together', 'QueenA', 8, Icons.music_note_rounded),
      ('Malam Santai', 'Nana', 6, Icons.nightlight_round),
      ('Ngobrol Yuk', 'Raka', 12, Icons.forum_rounded),
      ('Lounge Gold', 'Dimas', 5, Icons.workspace_premium_rounded),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _TopBar(
            title: 'Room',
            onSearch: () => _showMessage(context, 'Search room'),
            actions: [
              IconButton(
                onPressed: () => _showMessage(context, 'Create Room'),
                icon: const Icon(Icons.add_circle_outline, color: _C.brown),
              )
            ],
          ),
          const _SearchBox(hint: 'Search voice rooms'),
          const _SectionTitle('Hot Rooms'),
          ...rooms.map((r) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _LuxuryCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomDetailPage(
                        roomName: r.$1,
                        owner: r.$2,
                        seats: r.$3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: _C.surface2,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(r.$4, color: _C.brown, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.$1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: _C.text)),
                            const SizedBox(height: 5),
                            Text('Host ${r.$2} • ${r.$3}/12 people',
                                style: const TextStyle(
                                    color: _C.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: _C.muted),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class RoomDetailPage extends StatelessWidget {
  final String roomName;
  final String owner;
  final int seats;
  const RoomDetailPage({
    super.key,
    required this.roomName,
    required this.owner,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    final names = ['QueenA', 'Raka', 'Nana', 'Dimas', 'Salsa', 'Jep', 'Novi', 'Rio'];
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: Text(roomName,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () => _showMessage(context, 'Room settings'),
            icon: const Icon(Icons.more_horiz_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _LuxuryCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundColor: _C.gold2,
                        child: Icon(Icons.person, color: _C.brown, size: 46),
                      ),
                      const SizedBox(height: 10),
                      Text(owner,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: _C.text)),
                      const Text('Room owner',
                          style: TextStyle(color: _C.muted)),
                    ],
                  ),
                ),
                const _SectionTitle('Seats'),
                GridView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: .82,
                  ),
                  itemBuilder: (_, i) {
                    final occupied = i < seats.clamp(0, 8);
                    return _LuxuryCard(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundColor:
                                occupied ? _C.gold2 : _C.surface2,
                            child: Icon(
                              occupied ? Icons.person : Icons.add,
                              color: occupied ? _C.brown : _C.muted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            occupied ? names[i] : 'Seat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, color: _C.text),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const _SectionTitle('Chat'),
                _LuxuryCard(
                  child: Column(
                    children: [
                      _ChatLine('Raka', 'Suara kamu enak banget! ❤️'),
                      _ChatLine('Nana', 'Makasihh 😍'),
                      _ChatLine('Dimas', 'Request lagu dong'),
                      _ChatLine('Salsa', 'Boleh banget!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            color: _C.surface,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _C.surface2,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text('Say something...',
                        style: TextStyle(color: _C.muted)),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleAction(
                  icon: Icons.card_giftcard_rounded,
                  onTap: () => _showMessage(context, 'Gift'),
                ),
                const SizedBox(width: 8),
                _CircleAction(
                  icon: Icons.mic_rounded,
                  onTap: () => _showMessage(context, 'Microphone'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatLine extends StatelessWidget {
  final String name;
  final String message;
  const _ChatLine(this.name, this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: _C.gold2,
            child: Icon(Icons.person, color: _C.brown, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(color: _C.text, fontSize: 13),
                children: [
                  TextSpan(
                      text: '$name  ',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: message),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _TopBar(
            title: 'Family',
            onSearch: () => _showMessage(context, 'Search family'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: _C.line),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield_rounded, color: _C.gold, size: 72),
                  const SizedBox(height: 8),
                  const Text('STAR FAMILY',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: _C.text)),
                  const SizedBox(height: 4),
                  const Text('Together We Rise',
                      style: TextStyle(color: _C.muted)),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: .64,
                      minHeight: 10,
                      color: _C.gold,
                      backgroundColor: _C.surface2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Lv.5   •   320,450 / 500,000',
                      style: TextStyle(color: _C.brown2)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _FamilyAction(Icons.groups_rounded, 'Members', () {
                  _showMessage(context, 'Family Members');
                }),
                _FamilyAction(Icons.task_alt_rounded, 'Tasks', () {
                  _showMessage(context, 'Family Tasks');
                }),
                _FamilyAction(Icons.storefront_rounded, 'Store', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StorePage()));
                }),
                _FamilyAction(Icons.leaderboard_rounded, 'Leaderboard', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RankingPage(type: 'Family')));
                }),
              ],
            ),
          ),
          const _SectionTitle('Family Notice'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _LuxuryCard(
              child: const Text(
                'Tetap kompak, saling support dan jaga nama baik family kita 🤍',
                style: TextStyle(
                    color: _C.text, fontSize: 15, height: 1.45),
              ),
            ),
          ),
          const _SectionTitle('Family Activity'),
          ...['CICI BIGBOSS', 'GARRA', 'QueenA', 'Nana'].map(
            (name) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _LuxuryCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: _C.gold2,
                      child: Icon(Icons.person, color: _C.brown),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _C.text,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ),
                    const Text('Active',
                        style: TextStyle(color: _C.muted, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _FamilyAction(IconData icon, String label, VoidCallback onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: _C.surface, borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: _C.brown),
            ),
            const SizedBox(height: 6),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _C.text, fontSize: 11)),
          ],
        ),
      ),
    ),
  );
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _TopBar(
            title: 'Wallet',
            actions: [
              IconButton(
                onPressed: () => _showMessage(context, 'Wallet history'),
                icon: const Icon(Icons.receipt_long_outlined, color: _C.brown),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _C.line),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance',
                      style: TextStyle(color: _C.muted, fontSize: 14)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.monetization_on_rounded,
                          color: _C.gold, size: 31),
                      SizedBox(width: 10),
                      Text('125,500',
                          style: TextStyle(
                              color: _C.text,
                              fontSize: 28,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.diamond_rounded,
                          color: Color(0xFF4B94D8), size: 27),
                      SizedBox(width: 10),
                      Text('8,750',
                          style: TextStyle(
                              color: _C.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                _WalletAction(Icons.add_circle_outline, 'Top Up', () {
                  _showMessage(context, 'Top Up');
                }),
                _WalletAction(Icons.receipt_long_outlined, 'Transaction', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TransactionsPage()));
                }),
                _WalletAction(Icons.swap_horiz_rounded, 'Exchange', () {
                  _showMessage(context, 'Exchange');
                }),
                _WalletAction(Icons.card_giftcard_rounded, 'Gift Code', () {
                  _showMessage(context, 'Gift Code');
                }),
              ],
            ),
          ),
          const _SectionTitle('Coin Packages'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: const [
                _CoinPackage('10,000', 'Rp 11.500'),
                _CoinPackage('20,000', 'Rp 23.000'),
                _CoinPackage('50,000', 'Rp 57.500'),
                _CoinPackage('100,000', 'Rp 115.000'),
                _CoinPackage('200,000', 'Rp 230.000'),
                _CoinPackage('500,000', 'Rp 575.000'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _WalletAction(IconData icon, String title, VoidCallback onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(icon, color: _C.brown, size: 26),
            const SizedBox(height: 5),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _C.text, fontSize: 10)),
          ],
        ),
      ),
    ),
  );
}

class _CoinPackage extends StatelessWidget {
  final String coins;
  final String price;
  const _CoinPackage(this.coins, this.price);

  @override
  Widget build(BuildContext context) {
    return _LuxuryCard(
      onTap: () => _showMessage(context, 'Package $coins coins dipilih'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on_rounded, color: _C.gold, size: 30),
          const SizedBox(height: 7),
          Text(coins,
              style: const TextStyle(
                  color: _C.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(price, style: const TextStyle(color: _C.brown2)),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _TopBar(
            title: 'Profile',
            actions: [
              IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage())),
                icon: const Icon(Icons.settings_outlined, color: _C.brown),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _LuxuryCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: _C.gold2,
                    child: Icon(Icons.person, color: _C.brown, size: 58),
                  ),
                  const SizedBox(height: 10),
                  const Text('CUAN USER',
                      style: TextStyle(
                          color: _C.text,
                          fontSize: 21,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  const Text('ID: 1000001',
                      style: TextStyle(color: _C.muted)),
                  const SizedBox(height: 6),
                  const Text('Good Voice, Better Company',
                      style: TextStyle(color: _C.brown2)),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      _Stat('36', 'Visitors'),
                      _Stat('8', 'Following'),
                      _Stat('12', 'Followers'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.75,
              children: [
                _ProfileShortcut(Icons.diamond_rounded, 'SVIP',
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const VipPage()))),
                _ProfileShortcut(Icons.auto_awesome_rounded, 'Level',
                    () => _showMessage(context, 'Level')),
                _ProfileShortcut(Icons.account_balance_wallet_rounded, 'Wallet',
                    () => _showMessage(context, 'Buka Wallet dari menu bawah')),
                _ProfileShortcut(Icons.storefront_rounded, 'Store',
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const StorePage()))),
                _ProfileShortcut(Icons.inventory_2_rounded, 'Bag',
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const BagPage()))),
                _ProfileShortcut(Icons.emoji_events_rounded, 'Reward',
                    () => _showMessage(context, 'Reward')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ProfileRow('Family', Icons.groups_rounded, () {
            _showMessage(context, 'Family');
          }),
          _ProfileRow('CP', Icons.people_alt_rounded, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingPage(type: 'CP')));
          }),
          _ProfileRow('Brother & Sister', Icons.diversity_3_rounded, () {
            _showMessage(context, 'Brother & Sister');
          }),
          _ProfileRow('Invite Friends', Icons.person_add_alt_1_rounded, () {
            _showMessage(context, 'Invite Friends');
          }),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: _C.text, fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: _C.muted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ProfileShortcut extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ProfileShortcut(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return _LuxuryCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: _C.gold, size: 28),
          const SizedBox(width: 9),
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

Widget _ProfileRow(String title, IconData icon, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
    child: _LuxuryCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: _C.brown, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _C.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
          ),
          const Icon(Icons.chevron_right_rounded, color: _C.muted),
        ],
      ),
    ),
  );
}

class _SubPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _SubPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: child,
    );
  }
}

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => 'Frame ${i + 1}');
    return _SubPage(
      title: 'Store',
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .88,
        ),
        itemBuilder: (_, i) => _LuxuryCard(
          onTap: () => _showMessage(context, '${items[i]} dipilih'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_C.surface2, Color(0xFFEAD5AD)]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                    child: Icon(Icons.auto_awesome_rounded,
                        color: _C.gold, size: 42)),
              ),
              const SizedBox(height: 12),
              Text(items[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _C.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
              const SizedBox(height: 5),
              const Text('30 Days • 1,000,000 Coin',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _C.muted, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class BagPage extends StatelessWidget {
  const BagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Bag',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('My Items',
              style: TextStyle(
                  color: _C.text, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...['Royal Theme', 'Gold Frame', 'VIP Badge', 'Lucky Badge'].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LuxuryCard(
                onTap: () => _showMessage(context, '$item equipped'),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: _C.gold, size: 34),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              color: _C.text,
                              fontWeight: FontWeight.w800)),
                    ),
                    const Text('EQUIP',
                        style: TextStyle(
                            color: _C.brown2, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VipPage extends StatelessWidget {
  const VipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'VIP / SVIP',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LuxuryCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Icon(Icons.diamond_rounded, color: _C.gold, size: 68),
                const SizedBox(height: 10),
                const Text('SVIP 1',
                    style: TextStyle(
                        color: _C.text,
                        fontSize: 25,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('Exclusive privileges designed for you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _C.muted)),
                const SizedBox(height: 18),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _C.brown,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () => _showMessage(context, 'VIP purchase'),
                  child: const Text('Buy VIP'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Royal Privileges'),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .95,
            children: [
              _Privilege(Icons.badge_rounded, 'Badge'),
              _Privilege(Icons.auto_awesome_rounded, 'Frame'),
              _Privilege(Icons.text_fields_rounded, 'Color'),
              _Privilege(Icons.credit_card_rounded, 'Profile'),
              _Privilege(Icons.login_rounded, 'Entry'),
              _Privilege(Icons.message_rounded, 'Chat'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Privilege extends StatelessWidget {
  final IconData icon;
  final String title;
  const _Privilege(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return _LuxuryCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _C.gold, size: 30),
          const SizedBox(height: 8),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: _C.text, fontWeight: FontWeight.w700, fontSize: 11)),
        ],
      ),
    );
  }
}

class RankingPage extends StatelessWidget {
  final String type;
  const RankingPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final data = [
      ('CICI BIGBOSS', '82,450,000'),
      ('GARRA', '71,200,000'),
      ('QueenA', '65,900,000'),
      ('CUAN USER', '54,800,000'),
      ('Nana', '49,700,000'),
    ];
    return _SubPage(
      title: '$type Ranking',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LuxuryCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Icon(Icons.emoji_events_rounded,
                    color: _C.gold, size: 55),
                const SizedBox(height: 8),
                const Text('#28',
                    style: TextStyle(
                        color: _C.text,
                        fontSize: 38,
                        fontWeight: FontWeight.w900)),
                const Text('Your current ranking',
                    style: TextStyle(color: _C.muted)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(data.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LuxuryCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text('#${i + 1}',
                          style: const TextStyle(
                              color: _C.brown2,
                              fontWeight: FontWeight.w900)),
                    ),
                    const CircleAvatar(
                      backgroundColor: _C.gold2,
                      child: Icon(Icons.person, color: _C.brown),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(data[i].$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _C.text,
                              fontWeight: FontWeight.w800)),
                    ),
                    Text(data[i].$2,
                        style: const TextStyle(
                            color: _C.brown2, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Events',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final event in [
            ('Golden Voice', 'Join voice rooms and collect rewards.'),
            ('Family Challenge', 'Complete family tasks together.'),
            ('Weekend Party', 'Special room activities this weekend.'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LuxuryCard(
                onTap: () => _showMessage(context, event.$1),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded, color: _C.gold, size: 35),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.$1,
                              style: const TextStyle(
                                  color: _C.text,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(event.$2,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _C.muted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: _C.muted),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Recharge Coin', '+500,000', Icons.add_circle_outline),
      ('Gift to QueenA', '-100,000', Icons.card_giftcard_rounded),
      ('Room Reward', '+50,000', Icons.emoji_events_rounded),
      ('Recharge Coin', '+250,000', Icons.add_circle_outline),
    ];
    return _SubPage(
      title: 'Transactions',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LuxuryCard(
                child: Row(
                  children: [
                    Icon(row.$3, color: _C.gold, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(row.$1,
                          style: const TextStyle(
                              color: _C.text, fontWeight: FontWeight.w800)),
                    ),
                    Text(row.$2,
                        style: const TextStyle(
                            color: _C.brown2, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileRow('Account & Security', Icons.security_rounded, () {}),
          _ProfileRow('Notifications', Icons.notifications_outlined, () {}),
          _ProfileRow('Privacy', Icons.lock_outline_rounded, () {}),
          _ProfileRow('Language', Icons.language_rounded, () {}),
          _ProfileRow('About Cuan Party', Icons.info_outline_rounded, () {}),
        ],
      ),
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: _C.brown,
    ),
  );
}
