
import 'package:flutter/foundation.dart';
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

const _roomPurple = Color(0xFF7A3CFF);
const _roomGold = Color(0xFFFFD66B);

final ValueNotifier<int> testerCoinBalance = ValueNotifier<int>(125500);
final ValueNotifier<int> testerDiamondBalance = ValueNotifier<int>(8750);

enum _RoomEventType { chat, gift }

class _RoomEvent {
  final _RoomEventType type;
  final String from;
  final String text;
  final String? to;
  final int coinCost;

  const _RoomEvent.chat(this.from, this.text)
      : type = _RoomEventType.chat,
        to = null,
        coinCost = 0;

  const _RoomEvent.gift(this.from, this.to, this.text, this.coinCost)
      : type = _RoomEventType.gift;
}

final ValueNotifier<List<_RoomEvent>> roomEvents = ValueNotifier<List<_RoomEvent>>([
  const _RoomEvent.chat('Raka', 'Suara kamu enak banget! ❤️'),
  const _RoomEvent.chat('Nana', 'Makasihh 😍'),
  const _RoomEvent.chat('Dimas', 'Request lagu dong'),
  const _RoomEvent.chat('Salsa', 'Boleh banget!'),
]);

void _addRoomEvent(_RoomEvent event) {
  roomEvents.value = [...roomEvents.value, event];
}

void _setTesterCoins(int value) {
  testerCoinBalance.value = value < 0 ? 0 : value;
}

void _addTesterCoins(int value) {
  _setTesterCoins(testerCoinBalance.value + value);
}

void _setTesterDiamonds(int value) {
  testerDiamondBalance.value = value < 0 ? 0 : value;
}

void _addTesterDiamonds(int value) {
  _setTesterDiamonds(testerDiamondBalance.value + value);
}

final ValueNotifier<List<String>> testerTransactions = ValueNotifier<List<String>>([
  'Saldo awal testing +125,500 Coin',
]);

void _addTesterTransaction(String text) {
  testerTransactions.value = [text, ...testerTransactions.value];
}

void _rechargeForTesting(int coins) {
  _addTesterCoins(coins);
  _addTesterTransaction('Testing Recharge +${_formatCoins(coins)} Coin');
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
    ChatPage(),
    FamilyPage(),
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
      (Icons.chat_bubble_rounded, 'Message'),
      (Icons.groups_rounded, 'Family'),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserSearchPage())),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(color: _C.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: _C.line)),
          child: Row(children: [
            const Icon(Icons.search_rounded, color: _C.gold),
            const SizedBox(width: 10),
            Expanded(child: Text(hint, style: const TextStyle(color: _C.muted, fontSize: 14))),
          ]),
        ),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mainTab = 'Mine';
  String _mineTab = 'Dikunjungi';

  final _rooms = const [
    ('Chill Together', 'QueenA', '48.63M Gift', Icons.music_note_rounded),
    ('Night Vibes', 'Raka', '36.20M Gift', Icons.mic_external_on_rounded),
    ('Sultan Lounge', 'Nana', '29.80M Gift', Icons.workspace_premium_rounded),
    ('Fun Talk', 'Dimas', '18.45M Gift', Icons.forum_rounded),
  ];

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
                      Text('Good evening 👋', style: TextStyle(color: _C.muted, fontSize: 13)),
                      SizedBox(height: 3),
                      Text('CUAN PARTY', style: TextStyle(color: _C.text, fontSize: 20, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                _CircleAction(
                  icon: Icons.search_rounded,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserSearchPage())),
                ),
                const SizedBox(width: 8),
                _CircleAction(icon: Icons.notifications_none_rounded, onTap: () => _showMessage(context, 'Notifications')),
              ],
            ),
          ),
          const _SearchBox(hint: 'Search rooms, people or family'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(colors: [_C.brown, Color(0xFF9D6B32)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                border: Border.all(color: _C.gold2),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REAL VOICES', style: TextStyle(color: _C.gold2, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        SizedBox(height: 8),
                        Text('Find your people', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Discover people, rooms and moments.', style: TextStyle(color: Color(0xFFEAD9C0), fontSize: 13)),
                      ],
                    ),
                  ),
                  SizedBox(width: 92, height: 108, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.all(Radius.circular(24))), child: Icon(Icons.graphic_eq_rounded, size: 52, color: _C.gold2))),
                ],
              ),
            ),
          ),
          _MainTabBar(
            tabs: const ['Mine', 'Hot', 'Discover'],
            selected: _mainTab,
            onChanged: (v) => setState(() => _mainTab = v),
          ),
          const SizedBox(height: 8),
          if (_mainTab == 'Mine') _buildMine(),
          if (_mainTab == 'Hot') _buildHot(),
          if (_mainTab == 'Discover') _buildDiscover(),
        ],
      ),
    );
  }

  Widget _buildMine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MainTabBar(tabs: const ['Dikunjungi', 'Follow'], selected: _mineTab, compact: true, onChanged: (v) => setState(() => _mineTab = v)),
        const SizedBox(height: 10),
        if (_mineTab == 'Dikunjungi')
          ..._rooms.take(2).map((r) => _RoomHomeCard(room: r))
        else
          ..._rooms.skip(1).take(2).map((r) => _RoomHomeCard(room: r)),
      ],
    );
  }

  Widget _buildHot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.fromLTRB(20, 6, 20, 10), child: Text('Semua Room', style: TextStyle(color: _C.text, fontSize: 20, fontWeight: FontWeight.w900))),
        for (final room in _rooms) _RoomHomeCard(room: room),
      ],
    );
  }

  Widget _buildDiscover() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.fromLTRB(20, 6, 20, 10), child: Text('Game', style: TextStyle(color: _C.text, fontSize: 20, fontWeight: FontWeight.w900))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _GameTile('Lucky Dice', Icons.casino_rounded),
              _GameTile('Card Battle', Icons.style_rounded),
              _GameTile('Spin Wheel', Icons.settings_backup_restore_rounded),
              _GameTile('Quiz Room', Icons.help_outline_rounded),
              _GameTile('Guess Song', Icons.headphones_rounded),
              _GameTile('More Games', Icons.sports_esports_rounded, soon: true),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(20, 18, 20, 10), child: Text('Event', style: TextStyle(color: _C.text, fontSize: 20, fontWeight: FontWeight.w900))),
        for (final event in ['Golden Voice', 'Family Challenge', 'Weekend Party'])
          _HomeLink(icon: Icons.event_rounded, title: event, subtitle: 'Lihat event dan aktivitas terbaru', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsPage()))),
      ],
    );
  }
}

class _MainTabBar extends StatelessWidget {
  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onChanged;
  final bool compact;
  const _MainTabBar({required this.tabs, required this.selected, required this.onChanged, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 44 : 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = tabs[i] == selected;
          return ChoiceChip(
            label: Text(tabs[i]),
            selected: active,
            onSelected: (_) => onChanged(tabs[i]),
            selectedColor: _C.gold2,
            backgroundColor: _C.surface,
            labelStyle: TextStyle(color: active ? _C.brown : _C.muted, fontWeight: FontWeight.w800),
            side: BorderSide(color: active ? _C.gold : _C.line),
          );
        },
      ),
    );
  }
}

class _RoomHomeCard extends StatelessWidget {
  final (String, String, String, IconData) room;
  const _RoomHomeCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: _LuxuryCard(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomDetailPage(roomName: room.$1, owner: room.$2, seats: 10))),
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(width: 54, height: 54, decoration: BoxDecoration(color: _C.surface2, borderRadius: BorderRadius.circular(16)), child: Icon(room.$4, color: _C.gold, size: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(room.$1, style: const TextStyle(color: _C.text, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(room.$2, style: const TextStyle(color: _C.muted, fontSize: 12)),
            const SizedBox(height: 3),
            Text(room.$3, style: const TextStyle(color: _C.brown2, fontWeight: FontWeight.w800, fontSize: 12)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: _C.muted),
        ]),
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
      onTap: () {
        if (soon) {
          _showMessage(context, 'More Games segera hadir.');
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GameHubPage(initialGame: title)),
          );
        }
      },
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
      ('Chill Together', 'QueenA', 20, Icons.music_note_rounded),
      ('Malam Santai', 'Nana', 15, Icons.nightlight_round),
      ('Ngobrol Yuk', 'Raka', 10, Icons.forum_rounded),
      ('Lounge Gold', 'Dimas', 30, Icons.workspace_premium_rounded),
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
                            Text('Host ${r.$2} • ${r.$3} seats',
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

class RoomDetailPage extends StatefulWidget {
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
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _GiftFlight {
  final int id;
  final IconData icon;
  final Offset target;

  const _GiftFlight({required this.id, required this.icon, required this.target});
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  static const _roomTop = Color(0xFF120B3A);
  static const _roomBottom = Color(0xFF050B2D);
  static const _roomPurple = Color(0xFF7A3CFF);
  static const _roomBlue = Color(0xFF124BFF);
  static const _roomGold = Color(0xFFFFD66B);
  static const _roomText = Colors.white;

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _micOn = false;
  bool _speakerOn = true;
  bool _joined = true;
  int _capacity = 10;
  String _feedFilter = 'all';
  String _giftTarget = 'QueenA';
  late List<String?> _seatNames;
  late List<GlobalKey> _seatKeys;
  final GlobalKey _roomStackKey = GlobalKey();
  final List<_GiftFlight> _giftFlights = [];
  final Map<int, String> _seatEmojis = {};
  int _nextGiftFlightId = 0;

  @override
  void initState() {
    super.initState();
    _capacity = [10, 15, 20, 30].contains(widget.seats) ? widget.seats : 10;
    _seatNames = _makeSeats(_capacity);
    _seatKeys = List.generate(_capacity, (_) => GlobalKey());
    if (_seatNames.length > 5) _seatNames[5] = 'Jep';
    _giftTarget = _firstGiftTarget();
  }

  List<String?> _makeSeats(int count) {
    const names = [
      'QueenA', 'Raka', 'Nana', 'Dimas', 'Salsa',
      null, null, null, null, null,
      null, null, null, null, null,
      null, null, null, null, null,
      null, null, null, null, null,
      null, null, null, null, null,
    ];
    return List<String?>.generate(
      count,
      (i) => i < names.length ? names[i] : null,
    );
  }

  String _firstGiftTarget() {
    return 'Jep';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleJoin() {
    setState(() {
      _joined = !_joined;
      if (!_joined) {
        _micOn = false;
        for (var i = 0; i < _seatNames.length; i++) {
          if (_seatNames[i] == 'Jep') _seatNames[i] = null;
        }
      }
    });
    _showMessage(context, _joined ? 'Kamu masuk room.' : 'Kamu keluar dari room.');
  }

  void _toggleMic() {
    if (!_joined) {
      _showMessage(context, 'Masuk room dulu untuk menggunakan mic.');
      return;
    }
    setState(() => _micOn = !_micOn);
  }

  void _showRoomEmojiPicker() {
    const emojis = ['😀','😂','😍','🥰','😘','😎','🔥','❤️','💜','👏','🎉','🤣','😭','😱','👍','🙏','✨','💎','👑','✈️'];
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final emoji in emojis)
                InkWell(
                  onTap: () {
                    final seatIndex = _seatNames.indexOf('Jep');
                    if (seatIndex >= 0) {
                      setState(() => _seatEmojis[seatIndex] = emoji);
                      Future.delayed(const Duration(seconds: 5), () {
                        if (!mounted) return;
                        if (_seatEmojis[seatIndex] == emoji) {
                          setState(() => _seatEmojis.remove(seatIndex));
                        }
                      });
                    }
                    Navigator.pop(sheetContext);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(padding: const EdgeInsets.all(9), child: Text(emoji, style: const TextStyle(fontSize: 28))),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final value = _messageController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _addRoomEvent(_RoomEvent.chat('Jep', value));
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _takeSeat(int index) {
    if (!_joined) {
      _showMessage(context, 'Masuk room dulu untuk mengambil seat.');
      return;
    }
    if (_seatNames[index] != null && _seatNames[index] != 'Jep') {
      _showMessage(context, 'Seat ini sudah ditempati.');
      return;
    }
    setState(() {
      for (var i = 0; i < _seatNames.length; i++) {
        if (_seatNames[i] == 'Jep') _seatNames[i] = null;
      }
      _seatNames[index] = 'Jep';
    });
  }

  void _changeCapacity(int value) {
    setState(() {
      _capacity = value;
      final old = _seatNames.where((name) => name != null).toList();
      _seatNames = _makeSeats(value);
      _seatKeys = List.generate(value, (_) => GlobalKey());
      for (var i = 0; i < old.length && i < _seatNames.length; i++) {
        _seatNames[i] = old[i];
      }
      _giftTarget = _firstGiftTarget();
    });
    Navigator.pop(context);
    _showMessage(context, 'Room sekarang $_capacity kursi.');
  }

  void _showRoomSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _C.line,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Room Settings',
                style: TextStyle(
                  color: _C.text,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih kapasitas kursi room',
                style: TextStyle(color: _C.muted),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [10, 15, 20, 30].map((value) {
                  final selected = value == _capacity;
                  return ChoiceChip(
                    label: Text('$value Kursi'),
                    selected: selected,
                    onSelected: (_) => _changeCapacity(value),
                    selectedColor: _C.gold2,
                    labelStyle: TextStyle(
                      color: selected ? _C.brown : _C.text,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              const Text(
                'Kapasitas langsung mengubah jumlah seat yang tampil.',
                style: TextStyle(color: _C.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playGiftAnimation(IconData icon, String targetName) {
    final targetIndex = _seatNames.indexOf(targetName);
    final stackContext = _roomStackKey.currentContext;
    if (targetIndex < 0 || stackContext == null || targetIndex >= _seatKeys.length) {
      _showMessage(context, 'Gift terkirim ke $targetName');
      return;
    }

    final targetContext = _seatKeys[targetIndex].currentContext;
    if (targetContext == null) {
      _showMessage(context, 'Gift terkirim ke $targetName');
      return;
    }

    final stackBox = stackContext.findRenderObject() as RenderBox?;
    final targetBox = targetContext.findRenderObject() as RenderBox?;
    if (stackBox == null || targetBox == null || !stackBox.hasSize || !targetBox.hasSize) {
      _showMessage(context, 'Gift terkirim ke $targetName');
      return;
    }

    final targetGlobal = targetBox.localToGlobal(targetBox.size.center(Offset.zero));
    final stackGlobal = stackBox.localToGlobal(Offset.zero);
    final target = targetGlobal - stackGlobal;
    final id = _nextGiftFlightId++;

    setState(() {
      _giftFlights.add(_GiftFlight(id: id, icon: icon, target: target));
    });

    Future.delayed(const Duration(milliseconds: 760), () {
      if (!mounted) return;
      setState(() {
        _giftFlights.removeWhere((flight) => flight.id == id);
      });
    });
  }

  void _showGifts() {
    const gifts = [
      ('Royal Crown', Icons.workspace_premium_rounded, 200000),
      ('Golden Wings', Icons.flight_rounded, 20000),
      ('Love Crown', Icons.favorite_rounded, 20000),
      ('Fantasy', Icons.auto_awesome_rounded, 20000),
      ('Royal Car', Icons.directions_car_filled_rounded, 20000),
      ('Queen Crown', Icons.diamond_rounded, 20000),
      ('Royal Castle', Icons.castle_rounded, 20000),
      ('Golden Wings', Icons.flutter_dash_rounded, 20000),
    ];
    const quantities = [1, 7, 77, 777, 7777];

    String target = _giftTarget;
    int quantity = 1;
    int selectedGift = 0;
    String category = 'Gift';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final selected = gifts[selectedGift];
          final totalCost = selected.$3 * quantity;

          return Container(
            height: MediaQuery.of(sheetContext).size.height * .72,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF5B27A8), Color(0xFF160D35)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: testerCoinBalance,
              builder: (_, coins, __) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Row(
                        children: [
                          const Text(
                            'Gift',
                            style: TextStyle(
                              color: Color(0xFFFFD66B),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_formatCoins(coins)} Coin',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          for (final tab in const ['Gift', 'CP', 'Lucky Gift', 'Flag', 'Exclusive'])
                            GestureDetector(
                              onTap: () => setSheetState(() => category = tab),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Center(
                                  child: Text(
                                    tab,
                                    style: TextStyle(
                                      color: category == tab ? const Color(0xFFFFD66B) : Colors.white70,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: .72,
                        ),
                        itemCount: gifts.length,
                        itemBuilder: (_, index) {
                          final gift = gifts[index];
                          final active = selectedGift == index;
                          return _LuxuryGiftCard(
                            title: gift.$1,
                            icon: gift.$2,
                            cost: gift.$3,
                            active: active,
                            onTap: () => setSheetState(() => selectedGift = index),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.18),
                        border: const Border(top: BorderSide(color: Colors.white10)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final result = await showDialog<String>(
                                  context: sheetContext,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: const Color(0xFF25104B),
                                    title: const Text('Kirim gift ke', style: TextStyle(color: Colors.white)),
                                    content: DropdownButtonFormField<String>(
                                      value: target,
                                      dropdownColor: const Color(0xFF25104B),
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person, color: Color(0xFFFFD66B)),
                                      ),
                                      items: [
                                        const DropdownMenuItem(value: 'Jep', child: Text('Jep (Saya)')),
                                        for (final name in _seatNames.where((name) => name != null && name != 'Jep').cast<String>())
                                          DropdownMenuItem(value: name, child: Text(name)),
                                      ],
                                      onChanged: (value) => Navigator.pop(_, value),
                                    ),
                                  ),
                                );
                                if (result != null) setSheetState(() => target = result);
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.person_pin_circle_rounded, color: Color(0xFFFFD66B)),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      target == 'Jep' ? 'Jep (Saya)' : target,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF9D5CFF), width: 1.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: quantity,
                                dropdownColor: const Color(0xFF25104B),
                                iconEnabledColor: Colors.white,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                items: [for (final q in quantities) DropdownMenuItem(value: q, child: Text('x$q'))],
                                onChanged: (value) {
                                  if (value != null) setSheetState(() => quantity = value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: () {
                                if (coins < totalCost) {
                                  _showMessage(context, 'Coin tidak cukup. Butuh ${_formatCoins(totalCost)} Coin.');
                                  return;
                                }
                                _setTesterCoins(coins - totalCost);
                                final isSelfGift = target == 'Jep';
                                if (isSelfGift) _addTesterDiamonds(totalCost);
                                _giftTarget = target;
                                _addRoomEvent(_RoomEvent.gift('Jep', target, selected.$1, totalCost));
                                _addTesterTransaction(
                                  'Gift ${selected.$1} x$quantity → $target -${_formatCoins(totalCost)} Coin${isSelfGift ? ' / +${_formatCoins(totalCost)} Diamond' : ''}',
                                );
                                Navigator.pop(sheetContext);
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _playGiftAnimation(selected.$2, target);
                                  _showMessage(
                                    context,
                                    '${selected.$1} x$quantity dikirim ke ${target == 'Jep' ? 'Jep (Saya)' : target}',
                                  );
                                });
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF8E4BFF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              ),
                              child: const Text('Send', style: TextStyle(fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showGiftSuccess(
    BuildContext context,
    String giftName,
    IconData icon,
    String target,
    int cost,
    int quantity,
    int diamondEarned,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: _C.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [_C.gold2, _C.gold]),
              ),
              child: Icon(icon, color: _C.brown, size: 48),
            ),
            const SizedBox(height: 14),
            Text(
              '$giftName x$quantity',
              style: const TextStyle(
                color: _C.text,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Gift terkirim ke ${target == 'Jep' ? 'Jep (Saya)' : target}',
              style: const TextStyle(color: _C.brown2),
            ),
            const SizedBox(height: 4),
            Text(
              '-${_formatCoins(cost)} Coin',
              style: const TextStyle(
                color: _C.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (diamondEarned > 0) ...[
              const SizedBox(height: 4),
              Text(
                '+${_formatCoins(diamondEarned)} Diamond masuk',
                style: const TextStyle(
                  color: Color(0xFF4B94D8),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showExitOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: _C.line,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Keluar dari Room?',
                style: TextStyle(
                  color: _C.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.picture_in_picture_alt_rounded,
                    color: _C.gold),
                title: const Text('Minimize'),
                subtitle: const Text('Kembali ke halaman sebelumnya'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.close_rounded, color: _C.brown),
                title: const Text('Close Room'),
                subtitle: const Text('Tutup room dan keluar'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_roomTop, _roomBottom],
          ),
        ),
        child: Stack(
          key: _roomStackKey,
          clipBehavior: Clip.none,
          children: [
            SafeArea(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: _roomText),
                    ),
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: _roomGold,
                      child: Icon(Icons.person, color: _C.brown),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _roomText,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'ID: 222221  •  $_capacity seats',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.72),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RoomIconButton(
                      icon: Icons.ios_share_rounded,
                      onTap: () => _showMessage(context, 'Room link copied (tester).'),
                    ),
                    _RoomIconButton(
                      icon: Icons.report_gmailerrorred_rounded,
                      onTap: () => _showMessage(context, 'Report room'),
                    ),
                    _RoomIconButton(
                      icon: Icons.settings_rounded,
                      onTap: _showRoomSettings,
                    ),
                    _RoomIconButton(
                      icon: Icons.power_settings_new_rounded,
                      onTap: _showExitOptions,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _RoomBadge(icon: Icons.emoji_events_rounded, text: '48.63M'),
                    const Spacer(),
                    _RoomBadge(icon: Icons.local_fire_department_rounded, text: '1'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  children: [
                    const SizedBox(height: 4),
                    _SeatGrid(
                      seats: _seatNames,
                      seatKeys: _seatKeys,
                      seatEmojis: _seatEmojis,
                      onTap: _takeSeat,
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<List<_RoomEvent>>(
                      valueListenable: roomEvents,
                      builder: (_, events, __) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                _RoomTab(
                                  title: 'All',
                                  selected: _feedFilter == 'all',
                                  onTap: () => setState(() => _feedFilter = 'all'),
                                ),
                                _RoomTab(
                                  title: 'Chat',
                                  selected: _feedFilter == 'chat',
                                  onTap: () => setState(() => _feedFilter = 'chat'),
                                ),
                                _RoomTab(
                                  title: 'Gift',
                                  selected: _feedFilter == 'gift',
                                  onTap: () => setState(() => _feedFilter = 'gift'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.24),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(.08)),
                              ),
                              child: const Text(
                                "Welcome everyone! Let's chat and have fun together.",
                                style: TextStyle(
                                  color: _roomGold,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            for (final event in events.where((event) =>
                                _feedFilter == 'all' ||
                                (_feedFilter == 'chat' &&
                                    event.type == _RoomEventType.chat) ||
                                (_feedFilter == 'gift' &&
                                    event.type == _RoomEventType.gift)))
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _RoomEventBubble(event),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Say Hi',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(.72)),
                          filled: true,
                          fillColor: Colors.black.withOpacity(.28),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _RoomBottomButton(
                      icon: Icons.emoji_emotions_rounded,
                      onTap: _showRoomEmojiPicker,
                    ),
                    _RoomBottomButton(
                      icon: _speakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      onTap: () => setState(() => _speakerOn = !_speakerOn),
                    ),
                    _RoomBottomButton(
                      icon: _micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                      active: _micOn,
                      onTap: _toggleMic,
                    ),
                    _RoomBottomButton(
                      icon: Icons.mail_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage())),
                    ),
                    _RoomBottomButton(
                      icon: Icons.card_giftcard_rounded,
                      active: true,
                      onTap: _showGifts,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
            for (final flight in _giftFlights)
              _FlyingGift(
                key: ValueKey(flight.id),
                icon: flight.icon,
                target: flight.target,
              ),
          ],
        ),
      ),
    );
  }
}

class _FlyingGift extends StatefulWidget {
  final IconData icon;
  final Offset target;

  const _FlyingGift({super.key, required this.icon, required this.target});

  @override
  State<_FlyingGift> createState() => _FlyingGiftState();
}

class _FlyingGiftState extends State<_FlyingGift> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (_, __) {
        final t = _curve.value;
        final start = Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height * .40,
        );
        final position = Offset.lerp(start, widget.target, t) ?? widget.target;
        final scale = 1.0 - (.35 * t);
        return Positioned(
          left: position.dx - 34,
          top: position.dy - 34,
          child: IgnorePointer(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF24104F).withOpacity(.94),
                  border: Border.all(color: _RoomDetailPageState._roomGold, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xAA7A3CFF),
                      blurRadius: 22,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: _RoomDetailPageState._roomGold,
                  size: 38,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SeatGrid extends StatelessWidget {
  final List<String?> seats;
  final List<GlobalKey> seatKeys;
  final Map<int, String> seatEmojis;
  final ValueChanged<int> onTap;
  const _SeatGrid({required this.seats, required this.seatKeys, required this.seatEmojis, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: seats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 12, crossAxisSpacing: 8, childAspectRatio: .84),
      itemBuilder: (_, index) {
        final name = seats[index];
        final emoji = seatEmojis[index];
        return InkWell(
          key: seatKeys[index],
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(index),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.08),
                      border: Border.all(color: name == null ? Colors.white.withOpacity(.16) : _roomGold.withOpacity(.9), width: 1.5),
                      boxShadow: name != null ? [BoxShadow(color: _roomPurple.withOpacity(.55), blurRadius: 18)] : null,
                    ),
                    child: name == null ? const Icon(Icons.add_rounded, color: _roomGold, size: 24) : const Icon(Icons.person_rounded, color: _roomGold, size: 29),
                  ),
                  if (emoji != null)
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(.16)),
                      child: Text(emoji, style: const TextStyle(fontSize: 34)),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(name ?? 'No.${index + 1}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
        );
      },
    );
  }
}

class _RoomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoomIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 22),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _RoomBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RoomBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.25),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _RoomDetailPageState._roomGold, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  const _RoomTab({required this.title, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: selected ? _RoomDetailPageState._roomGold : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 2,
                width: selected ? 28 : 0,
                color: _RoomDetailPageState._roomGold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomEventBubble extends StatelessWidget {
  final _RoomEvent event;
  const _RoomEventBubble(this.event);

  @override
  Widget build(BuildContext context) {
    final isGift = event.type == _RoomEventType.gift;
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${event.from}  ',
              style: const TextStyle(
                color: _RoomDetailPageState._roomGold,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: isGift
                  ? 'mengirim ${event.text} ke ${event.to} • ${_formatCoins(event.coinCost)} Coin'
                  : event.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _RoomBottomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _RoomBottomButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: active ? _RoomDetailPageState._roomGold : Colors.white,
        size: 25,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(.22),
      ),
    );
  }
}

class _LuxuryGiftCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int cost;
  final bool active;
  final VoidCallback onTap;

  const _LuxuryGiftCard({
    required this.title,
    required this.icon,
    required this.cost,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 7),
        decoration: BoxDecoration(
          color: const Color(0xFF281452),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFFB45CFF) : Colors.white12,
            width: active ? 2 : 1,
          ),
          boxShadow: active
              ? [BoxShadow(color: const Color(0xFF8E4BFF).withOpacity(.35), blurRadius: 12)]
              : null,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF39206C), Color(0xFF130B2E)],
                  ),
                ),
                child: Icon(icon, color: const Color(0xFFEED7FF), size: 38),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on_rounded, color: Color(0xFFFFD66B), size: 12),
                const SizedBox(width: 2),
                Text(
                  _formatCoins(cost),
                  style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
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

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  bool hasFamily = false;
  bool isOwner = false;
  String? joinedFamily;

  final families = const [
    ('STAR FAMILY', 'Together We Rise', 320450, 500000, 58),
    ('HAPPY FAMILY', 'Always Together', 218900, 400000, 42),
    ('BIGBOSS FAMILY', 'Royal Voice Community', 487200, 600000, 76),
    ('SAYANG FAMILY', 'Good Vibes Only', 125600, 300000, 31),
  ];

  void _openFamilyProfile(String name, String slogan) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FamilyDetailPage(
      name: name,
      slogan: slogan,
      isOwner: false,
      isMember: false,
      onJoin: () {
        setState(() {
          hasFamily = true;
          isOwner = false;
          joinedFamily = name;
        });
      },
    )));
  }

  void _createFamily() {
    final name = TextEditingController();
    final slogan = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buat Family', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama Family')),
            TextField(controller: slogan, decoration: const InputDecoration(labelText: 'Slogan / deskripsi')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _C.brown),
            onPressed: () {
              if (name.text.trim().isEmpty) return;
              setState(() {
                hasFamily = true;
                isOwner = true;
                joinedFamily = name.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasFamily && joinedFamily != null) {
      return SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            _TopBar(
              title: joinedFamily!,
              actions: [
                if (isOwner)
                  IconButton(
                    tooltip: 'Setting',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FamilySettingPage(familyName: joinedFamily!))),
                    icon: const Icon(Icons.settings_rounded),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: _LuxuryCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 44, backgroundColor: _C.gold2, child: Icon(Icons.shield_rounded, color: _C.brown, size: 48)),
                    const SizedBox(height: 12),
                    Text(joinedFamily!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('Together We Rise', style: TextStyle(color: _C.muted)),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _FamilyAction(Icons.chat_bubble_rounded, 'Obrolan', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyChatPage())))),
                        Expanded(child: _FamilyAction(Icons.emoji_events_rounded, 'Trophy', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyTrophyPage())))),
                        if (isOwner)
                          Expanded(child: _FamilyAction(Icons.settings_rounded, 'Setting', () => Navigator.push(context, MaterialPageRoute(builder: (_) => FamilySettingPage(familyName: joinedFamily!))))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const _SectionTitle('Announcement'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _LuxuryCard(child: Text(isOwner ? 'Belum ada pengumuman. Buat dari Setting.' : 'Selamat datang di ${joinedFamily!} 🤍', style: const TextStyle(color: _C.text, height: 1.45))),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _TopBar(
            title: 'Family',
            actions: [
              IconButton(
                tooltip: 'Buat Family',
                onPressed: _createFamily,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text('Pilih Family untuk bergabung', style: TextStyle(color: _C.muted, fontSize: 13)),
          ),
          for (final family in families)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _LuxuryCard(
                onTap: () => _openFamilyProfile(family.$1, family.$2),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 30, backgroundColor: _C.gold2, child: Icon(Icons.shield_rounded, color: _C.brown, size: 32)),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(family.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(family.$2, style: const TextStyle(color: _C.muted, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text('${family.$5}% • ${_formatCoins(family.$3)} / ${_formatCoins(family.$4)}', style: const TextStyle(color: _C.brown2, fontSize: 11, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: _C.muted),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FamilyDetailPage extends StatelessWidget {
  final String name;
  final String slogan;
  final bool isOwner;
  final bool isMember;
  final VoidCallback? onJoin;
  const FamilyDetailPage({super.key, required this.name, required this.slogan, required this.isOwner, required this.isMember, this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(backgroundColor: _C.bg, foregroundColor: _C.text, title: const Text('Profil Family', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LuxuryCard(
            padding: const EdgeInsets.all(22),
            child: Column(children: [
              const CircleAvatar(radius: 52, backgroundColor: _C.gold2, child: Icon(Icons.shield_rounded, color: _C.brown, size: 54)),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              Text(slogan, style: const TextStyle(color: _C.muted)),
              const SizedBox(height: 18),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _FamilyStat('Level', '5'),
                _FamilyStat('Member', '28'),
                _FamilyStat('Trophy', '126'),
              ]),
              const SizedBox(height: 22),
              if (!isMember && !isOwner)
                SizedBox(width: double.infinity, child: FilledButton(onPressed: () { onJoin?.call(); Navigator.pop(context); _showMessage(context, 'Request JOIN FAMILY terkirim.'); }, style: FilledButton.styleFrom(backgroundColor: _C.brown), child: const Text('JOIN FAMILY'))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _FamilyStat extends StatelessWidget {
  final String label;
  final String value;
  const _FamilyStat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: _C.muted, fontSize: 11))]);
}

class FamilySettingPage extends StatefulWidget {
  final String familyName;
  const FamilySettingPage({super.key, required this.familyName});
  @override
  State<FamilySettingPage> createState() => _FamilySettingPageState();
}

class _FamilySettingPageState extends State<FamilySettingPage> {
  late final TextEditingController nameController = TextEditingController(text: widget.familyName);
  final announcementController = TextEditingController();
  @override
  void dispose() { nameController.dispose(); announcementController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(backgroundColor: _C.bg, foregroundColor: _C.text, title: const Text('Family Setting', style: TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _LuxuryCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Foto Family', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Center(child: Stack(children: [const CircleAvatar(radius: 52, backgroundColor: _C.gold2, child: Icon(Icons.shield_rounded, color: _C.brown, size: 54)), Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 17, backgroundColor: _C.brown, child: IconButton(padding: EdgeInsets.zero, onPressed: () => _showMessage(context, 'Pilih foto Family'), icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 17)))) ])),
          const SizedBox(height: 22),
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Family')),
          const SizedBox(height: 14),
          TextField(controller: announcementController, maxLines: 4, decoration: const InputDecoration(labelText: 'Announcement / Pengumuman')),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () { Navigator.pop(context); _showMessage(context, 'Family berhasil disimpan.'); }, style: FilledButton.styleFrom(backgroundColor: _C.brown), child: const Text('SUBMIT / SAVE'))),
        ])),
      ]),
    );
  }
}

class FamilyChatPage extends StatelessWidget {
  const FamilyChatPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: _C.bg, appBar: AppBar(backgroundColor: _C.bg, foregroundColor: _C.text, title: const Text('Obrolan Family', style: TextStyle(fontWeight: FontWeight.w900))), body: const Center(child: Text('Group Chat Family')));
}

class FamilyTrophyPage extends StatelessWidget {
  const FamilyTrophyPage({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(length: 2, child: Scaffold(backgroundColor: _C.bg, appBar: AppBar(backgroundColor: _C.bg, foregroundColor: _C.text, title: const Text('Trophy Family', style: TextStyle(fontWeight: FontWeight.w900)), bottom: const TabBar(tabs: [Tab(text: 'Weekly'), Tab(text: 'Monthly')])), body: const TabBarView(children: [
    _TrophyList(title: 'Family Weekly Ranking'),
    _TrophyList(title: 'Family Monthly Ranking'),
  ])));
}

class _TrophyList extends StatelessWidget {
  final String title;
  const _TrophyList({required this.title});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    _LuxuryCard(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
    const SizedBox(height: 10),
    for (int i = 1; i <= 5; i++) Padding(padding: const EdgeInsets.only(bottom: 8), child: _LuxuryCard(child: Row(children: [Text('#$i', style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(width: 14), const Icon(Icons.shield_rounded, color: _C.gold), const SizedBox(width: 10), Expanded(child: Text('Family ${String.fromCharCode(64 + i)}', style: const TextStyle(fontWeight: FontWeight.w800))), Text('${5000 - i * 420} pts', style: const TextStyle(color: _C.brown2))]))),
  ]);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: TextStyle(color: _C.muted, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _BalanceTile(icon: Icons.monetization_on_rounded, label: 'Coin', color: _C.gold, valueListenable: testerCoinBalance)),
                      const SizedBox(width: 10),
                      Expanded(child: _BalanceTile(icon: Icons.diamond_rounded, label: 'Diamond', color: Color(0xFF4B94D8), valueListenable: testerDiamondBalance)),
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
                  _showTestingRecharge(context);
                }),
                _WalletAction(Icons.receipt_long_outlined, 'Transaction', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TransactionsPage()));
                }),
                _WalletAction(Icons.swap_horiz_rounded, 'Exchange', () {
                  _showTestingExchange(context);
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
              children: [
                _CoinPackage('10,000', 'Rp 11.500', onTap: () => _rechargeForTesting(10000)),
                _CoinPackage('20,000', 'Rp 23.000', onTap: () => _rechargeForTesting(20000)),
                _CoinPackage('50,000', 'Rp 57.500', onTap: () => _rechargeForTesting(50000)),
                _CoinPackage('100,000', 'Rp 115.000', onTap: () => _rechargeForTesting(100000)),
                _CoinPackage('200,000', 'Rp 230.000', onTap: () => _rechargeForTesting(200000)),
                _CoinPackage('500,000', 'Rp 575.000', onTap: () => _rechargeForTesting(500000)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ValueListenable<int> valueListenable;
  const _BalanceTile({required this.icon, required this.label, required this.color, required this.valueListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: valueListenable,
      builder: (_, value, __) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: _C.bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: _C.line)),
        child: Row(children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: _C.muted, fontSize: 11)),
            const SizedBox(height: 2),
            FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text(_formatCoins(value), style: const TextStyle(color: _C.text, fontSize: 18, fontWeight: FontWeight.w900))),
          ])),
        ]),
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
  final VoidCallback onTap;
  const _CoinPackage(this.coins, this.price, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _LuxuryCard(
      onTap: () {
        onTap();
        _showMessage(context, '$coins Coin ditambahkan untuk testing.');
      },
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
          const SizedBox(height: 4),
          const Text('TEST ADD', style: TextStyle(color: _C.gold, fontSize: 9, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

void _showTestingRecharge(BuildContext context) {
  final controller = TextEditingController(text: '1000000');
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: _C.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
      child: StatefulBuilder(
        builder: (context, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Testing Recharge', style: TextStyle(color: _C.text, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            const Text('Khusus build testing. Coin langsung masuk ke Wallet.', style: TextStyle(color: _C.muted)),
            const SizedBox(height: 14),
            ValueListenableBuilder<int>(
              valueListenable: testerCoinBalance,
              builder: (_, coins, __) => Text('Saldo: ${_formatCoins(coins)} Coin', style: const TextStyle(color: _C.brown, fontWeight: FontWeight.w900, fontSize: 18)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [100000, 500000, 1000000, 5000000].map((amount) => ActionChip(
                label: Text('+${_formatCoins(amount)}'),
                onPressed: () { _rechargeForTesting(amount); setSheetState(() {}); },
              )).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Coin', prefixIcon: Icon(Icons.monetization_on_rounded), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final amount = int.tryParse(controller.text.replaceAll(',', '').trim());
                  if (amount == null || amount <= 0) return;
                  _rechargeForTesting(amount);
                  Navigator.pop(sheetContext);
                  _showMessage(context, '${_formatCoins(amount)} Coin ditambahkan.');
                },
                style: FilledButton.styleFrom(backgroundColor: _C.brown, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50)),
                child: const Text('Tambah Coin'),
              ),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(controller.dispose);
}

void _showTestingExchange(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        final raw = controller.text.replaceAll(',', '').trim();
        final diamonds = int.tryParse(raw) ?? 0;
        final validAmount = diamonds > 0 && diamonds % 100 == 0;
        final coinResult = validAmount ? (diamonds * 70) ~/ 100 : 0;

        return AlertDialog(
          title: const Text('Tukar Diamond'),
          content: ValueListenableBuilder<int>(
            valueListenable: testerDiamondBalance,
            builder: (_, balance, __) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rate testing:'),
                const SizedBox(height: 6),
                const Text('100 Diamond → 70 Coin (70%)'),
                const SizedBox(height: 14),
                Text('Saldo Diamond: ${_formatCoins(balance)}'),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Diamond',
                    hintText: 'Contoh: 1000',
                    suffixText: 'Diamond',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  validAmount
                      ? '${_formatCoins(diamonds)} Diamond → ${_formatCoins(coinResult)} Coin'
                      : 'Isi kelipatan 100 Diamond.',
                  style: TextStyle(
                    color: validAmount ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final amount = int.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
                if (amount <= 0 || amount % 100 != 0) {
                  _showMessage(context, 'Jumlah Diamond harus kelipatan 100.');
                  return;
                }
                if (amount > testerDiamondBalance.value) {
                  _showMessage(context, 'Diamond tidak cukup.');
                  return;
                }

                final coins = (amount * 70) ~/ 100;
                _setTesterDiamonds(testerDiamondBalance.value - amount);
                _addTesterCoins(coins);
                _addTesterTransaction(
                  '-${_formatCoins(amount)} Diamond → +${_formatCoins(coins)} Coin',
                );
                Navigator.pop(dialogContext);
                _showMessage(
                  context,
                  'Penukaran berhasil: -${_formatCoins(amount)} Diamond, +${_formatCoins(coins)} Coin.',
                );
              },
              child: const Text('Tukar Diamond'),
            ),
          ],
        );
      },
    ),
  ).whenComplete(controller.dispose);
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
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const WalletPage()))),
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

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String tab = 'Frame';
  final tabs = const ['Frame', 'Kendaraan', 'Dekorasi Profil', 'Badge', 'VIP/SVIP', 'Tema'];

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Store',
      child: Column(children: [
        _MainTabBar(tabs: tabs, selected: tab, onChanged: (v) => setState(() => tab = v), compact: true),
        const SizedBox(height: 8),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .88),
          itemBuilder: (_, i) => _LuxuryCard(
            onTap: () => _showMessage(context, '$tab ${i + 1} dipilih'),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(height: 80, decoration: BoxDecoration(gradient: const LinearGradient(colors: [_C.surface2, Color(0xFFEAD5AD)]), borderRadius: BorderRadius.circular(18)), child: Center(child: Icon(_storeIcon(tab), color: _C.gold, size: 42))),
              const SizedBox(height: 12),
              Text('$tab ${i + 1}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _C.text, fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 5),
              const Text('30 Days • 1,000,000 Coin', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _C.muted, fontSize: 10)),
            ]),
          ),
        )),
      ]),
    );
  }

  IconData _storeIcon(String value) {
    switch (value) {
      case 'Kendaraan': return Icons.directions_car_rounded;
      case 'Dekorasi Profil': return Icons.palette_rounded;
      case 'Badge': return Icons.verified_rounded;
      case 'VIP/SVIP': return Icons.diamond_rounded;
      case 'Tema': return Icons.auto_awesome_rounded;
      default: return Icons.crop_free_rounded;
    }
  }
}

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  String tab = 'Bingkai';
  final tabs = const ['Bingkai', 'Kendaraan', 'Dekorasi Profil', 'Badge', 'VIP/SVIP', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Bag',
      child: Column(children: [
        _MainTabBar(tabs: tabs, selected: tab, onChanged: (v) => setState(() => tab = v), compact: true),
        const SizedBox(height: 8),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: 8,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LuxuryCard(
              onTap: () => _showMessage(context, '$tab ${i + 1} equipped'),
              child: Row(children: [
                Icon(_bagIcon(tab), color: _C.gold, size: 34),
                const SizedBox(width: 14),
                Expanded(child: Text('$tab ${i + 1}', style: const TextStyle(color: _C.text, fontWeight: FontWeight.w800))),
                const Text('EQUIP', style: TextStyle(color: _C.brown2, fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
        )),
      ]),
    );
  }

  IconData _bagIcon(String value) {
    switch (value) {
      case 'Kendaraan': return Icons.directions_car_rounded;
      case 'Dekorasi Profil': return Icons.palette_rounded;
      case 'Badge': return Icons.verified_rounded;
      case 'VIP/SVIP': return Icons.diamond_rounded;
      default: return Icons.auto_awesome_rounded;
    }
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
    return _SubPage(
      title: 'Transactions',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ValueListenableBuilder<List<String>>(
            valueListenable: testerTransactions,
            builder: (_, rows, __) => Column(
              children: [
                for (final row in rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LuxuryCard(
                      child: Row(
                        children: [
                          Icon(row.contains('Gift') ? Icons.card_giftcard_rounded : Icons.monetization_on_rounded, color: _C.gold, size: 30),
                          const SizedBox(width: 12),
                          Expanded(child: Text(row, style: const TextStyle(color: _C.text, fontWeight: FontWeight.w800))),
                        ],
                      ),
                    ),
                  ),
              ],
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
          _ProfileRow('Testing Wallet', Icons.science_rounded, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TestingWalletPage()),
            );
          }),
        ],
      ),
    );
  }
}


class TestingWalletPage extends StatefulWidget {
  const TestingWalletPage({super.key});

  @override
  State<TestingWalletPage> createState() => _TestingWalletPageState();
}

class _TestingWalletPageState extends State<TestingWalletPage> {
  final _controller = TextEditingController(text: '1000000');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setFromField() {
    final value = int.tryParse(_controller.text.replaceAll(',', '').trim());
    if (value == null || value < 0) {
      _showMessage(context, 'Masukkan jumlah Coin yang valid.');
      return;
    }
    _setTesterCoins(value);
    setState(() {});
    _showMessage(context, 'Coin berhasil diubah.');
  }

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Testing Wallet',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LuxuryCard(
            padding: const EdgeInsets.all(22),
            child: ValueListenableBuilder<int>(
              valueListenable: testerCoinBalance,
              builder: (_, coins, __) => Column(
                children: [
                  const Icon(Icons.science_rounded, color: _C.gold, size: 58),
                  const SizedBox(height: 10),
                  const Text(
                    'Testing Coin',
                    style: TextStyle(
                      color: _C.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatCoins(coins),
                    style: const TextStyle(
                      color: _C.brown,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Bebas diatur untuk kebutuhan testing.',
                    style: TextStyle(color: _C.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _LuxuryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atur jumlah Coin',
                  style: TextStyle(
                    color: _C.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Coin',
                    prefixIcon: Icon(Icons.monetization_on_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _setFromField,
                  style: FilledButton.styleFrom(
                    backgroundColor: _C.brown,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Set Coin'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () {
                    _addTesterCoins(100000);
                    setState(() {});
                  },
                  child: const Text('+100K'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () {
                    _addTesterCoins(1000000);
                    setState(() {});
                  },
                  child: const Text('+1M'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _setTesterCoins(0);
                    setState(() {});
                  },
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final _controller = TextEditingController();
  String? _foundId;

  void _search() {
    final id = _controller.text.trim();
    setState(() => _foundId = id == '1000001' ? id : null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: const Text('Cari ID Pengguna', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Masukkan ID pengguna',
              prefixIcon: const Icon(Icons.search_rounded, color: _C.gold),
              suffixIcon: IconButton(onPressed: _search, icon: const Icon(Icons.arrow_forward_rounded)),
              filled: true,
              fillColor: _C.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: _C.line)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: _C.line)),
            ),
          ),
          const SizedBox(height: 18),
          if (_foundId == null && _controller.text.isNotEmpty)
            const _LuxuryCard(child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('User tidak ditemukan.', style: TextStyle(color: _C.muted)),
            )),
          if (_foundId != null)
            _LuxuryCard(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivateChatPage(userName: 'CUAN USER', userId: '1000001'))),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(radius: 28, backgroundColor: _C.gold2, child: Icon(Icons.person, color: _C.brown)),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('CUAN USER', style: TextStyle(color: _C.text, fontWeight: FontWeight.w900, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('ID: 1000001', style: TextStyle(color: _C.muted)),
                  ])),
                  const Icon(Icons.chat_bubble_outline_rounded, color: _C.gold),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text('Testing: gunakan ID 1000001 untuk membuka profil chat.', style: TextStyle(color: _C.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class PrivateChatPage extends StatefulWidget {
  final String userName;
  final String userId;
  const PrivateChatPage({super.key, required this.userName, required this.userId});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final _controller = TextEditingController();
  final _messages = <String>['Halo 👋', 'Hai, salam kenal! 😊'];

  void _send() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _messages.add(value);
      _controller.clear();
    });
  }

  void _emoji() {
    const emojis = ['😀','😂','😍','🥰','😘','😎','🔥','❤️','💜','👏','🎉','🤣','😭','😱','👍','🙏','✨','💎','👑','✈️'];
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final emoji in emojis) InkWell(
              onTap: () { _controller.text += emoji; Navigator.pop(sheetContext); setState(() {}); },
              borderRadius: BorderRadius.circular(14),
              child: Padding(padding: const EdgeInsets.all(8), child: Text(emoji, style: const TextStyle(fontSize: 28))),
            )],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: Row(children: [
          const CircleAvatar(radius: 18, backgroundColor: _C.gold2, child: Icon(Icons.person, color: _C.brown, size: 20)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            Text('ID: ${widget.userId}', style: const TextStyle(fontSize: 11, color: _C.muted)),
          ]),
        ]),
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          itemCount: _messages.length,
          itemBuilder: (_, i) => Align(
            alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: i.isEven ? _C.surface : _C.gold2, borderRadius: BorderRadius.circular(18)),
              child: Text(_messages[i], style: const TextStyle(color: _C.text, fontSize: 14)),
            ),
          ),
        )),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(children: [
              IconButton(onPressed: _emoji, icon: const Icon(Icons.emoji_emotions_rounded, color: _C.gold)),
              Expanded(child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(hintText: 'Tulis pesan...', filled: true, fillColor: _C.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: _C.line)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: _C.line)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              )),
              const SizedBox(width: 6),
              IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: _C.brown)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _items = const [
    _ChatItem('Nana', 'Kamu on malam ini? 😍', '2m', 3),
    _ChatItem('Raka', 'Voice call?', '10m', 0),
    _ChatItem('Salsa', 'Oke deh, sampai nanti!', '1h', 0),
    _ChatItem('Dimas', 'Mantap!', '2h', 0),
    _ChatItem('Official Cuan Party', 'Event baru sudah hadir!', '3h', 0),
    _ChatItem('System', 'Your Coins have been updated', '1d', 0),
  ];

  final _users = const [
    ('Nana', '1000002'), ('Raka', '1000003'), ('Salsa', '1000004'), ('Dimas', '1000005'), ('QueenA', '1000006'), ('Jep', '1000001'),
  ];

  final _requests = <Map<String, String>>[
    {'name': 'Miauu', 'id': '1000011'},
    {'name': 'AL01', 'id': '1000012'},
  ];

  void _searchUser() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pencarian User', style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Masukkan User ID')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: _C.brown), onPressed: () { Navigator.pop(dialogContext); _showSearchResult(controller.text.trim()); }, child: const Text('Cari')),
        ],
      ),
    );
  }

  void _showSearchResult(String id) {
    if (id.isEmpty) { _showMessage(context, 'Masukkan ID user.'); return; }
    final match = _users.where((u) => u.$2 == id).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: match.isEmpty ? const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.person_search_rounded, size: 46, color: _C.muted), SizedBox(height: 8), Text('User ID tidak ditemukan'), SizedBox(height: 16)]) : Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 34, backgroundColor: _C.gold2, child: const Icon(Icons.person, color: _C.brown, size: 34)),
        const SizedBox(height: 10), Text(match.first.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text('ID: ${match.first.$2}', style: const TextStyle(color: _C.muted)),
        const SizedBox(height: 18), Row(children: [Expanded(child: OutlinedButton(onPressed: () { Navigator.pop(context); _showMessage(context, 'Permintaan pertemanan dikirim.'); }, child: const Text('Tambah Teman'))), const SizedBox(width: 10), Expanded(child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _C.brown), onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => PrivateChatPage(userName: match.first.$1, userId: match.first.$2))); }, child: const Text('Pesan')))])
      ]))),
    );
  }

  void _friendRequests() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (_, modalSetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Permintaan Teman',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_requests.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Tidak ada permintaan teman.',
                          style: TextStyle(color: _C.muted),
                        ),
                      )
                    else
                      ..._requests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LuxuryCard(
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: _C.gold2,
                                  child: Icon(Icons.person, color: _C.brown),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request['name']!,
                                        style: const TextStyle(fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        'ID: ${request['id']}',
                                        style: const TextStyle(color: _C.muted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    modalSetState(() => _requests.remove(request));
                                    setState(() {});
                                  },
                                  child: const Text('Tolak'),
                                ),
                                const SizedBox(width: 6),
                                FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: _C.brown),
                                  onPressed: () {
                                    modalSetState(() => _requests.remove(request));
                                    setState(() {});
                                    _showMessage(
                                      context,
                                      '${request['name']} sekarang menjadi teman.',
                                    );
                                  },
                                  child: const Text('Terima'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: _C.bg, body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 12, 8), child: Row(children: [const Expanded(child: Text('Message', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _C.text))), IconButton(tooltip: 'Pencarian', onPressed: _searchUser, icon: const Icon(Icons.search_rounded, color: _C.brown)), IconButton(tooltip: 'Permintaan Teman', onPressed: _friendRequests, icon: const Icon(Icons.person_add_alt_1_rounded, color: _C.brown))])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), child: Row(children: [Expanded(child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: _C.brown), child: const Text('Messages'))), const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: () => _showMessage(context, 'Friends'), child: const Text('Friends')))])),
      const SizedBox(height: 8),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            for (final item in _items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LuxuryCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrivateChatPage(
                        userName: item.name,
                        userId: item.name == 'Nana'
                            ? '1000002'
                            : item.name == 'Raka'
                                ? '1000003'
                                : '1000004',
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: _C.gold2,
                        child: Icon(
                          item.name == 'System'
                              ? Icons.lock_rounded
                              : item.name.startsWith('Official')
                                  ? Icons.workspace_premium_rounded
                                  : Icons.person,
                          color: _C.brown,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: _C.text,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _C.muted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.time,
                            style: const TextStyle(color: _C.muted, fontSize: 11),
                          ),
                          if (item.unread > 0) ...[
                            const SizedBox(height: 6),
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: _C.gold,
                              child: Text(
                                '${item.unread}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ])));
  }
}

class _ChatItem {
  final String name;
  final String preview;
  final String time;
  final int unread;
  const _ChatItem(this.name, this.preview, this.time, this.unread);
}

class GameHubPage extends StatelessWidget {
  final String initialGame;
  const GameHubPage({super.key, this.initialGame = 'Lucky Dice'});

  @override
  Widget build(BuildContext context) {
    final games = [
      ('Lucky Dice', Icons.casino_rounded),
      ('Card Battle', Icons.style_rounded),
      ('Spin Wheel', Icons.settings_backup_restore_rounded),
      ('Quiz Room', Icons.help_outline_rounded),
      ('Guess Song', Icons.headphones_rounded),
    ];
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: const Text(
          'Game',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LuxuryCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _C.surface2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    games.firstWhere(
                      (g) => g.$1 == initialGame,
                      orElse: () => games.first,
                    ).$2,
                    color: _C.gold,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        initialGame,
                        style: const TextStyle(
                          color: _C.text,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Game Hub',
                        style: TextStyle(color: _C.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final game in games)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LuxuryCard(
                onTap: () => _showMessage(
                  context,
                  '${game.$1} siap untuk integrasi gameplay.',
                ),
                child: Row(
                  children: [
                    Icon(game.$2, color: _C.gold, size: 30),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        game.$1,
                        style: const TextStyle(
                          color: _C.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Text(
                      'Play',
                      style: TextStyle(
                        color: _C.brown2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _formatCoins(int value) {
  return value.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
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
