
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
          _HomeLink(
            icon: Icons.chat_bubble_rounded,
            title: 'Chat',
            subtitle: 'Messages & friends',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            ),
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
                      onTap: () => _showMessage(context, 'Emoji picker (tester).'),
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
                      onTap: _sendMessage,
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
  final ValueChanged<int> onTap;
  const _SeatGrid({required this.seats, required this.seatKeys, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: seats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: .84,
      ),
      itemBuilder: (_, index) {
        final name = seats[index];
          return InkWell(
            key: seatKeys[index],
            borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(index),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.08),
                  border: Border.all(
                    color: name == null
                        ? Colors.white.withOpacity(.16)
                        : _roomGold.withOpacity(.9),
                    width: 1.5,
                  ),
                  boxShadow: name != null
                      ? [
                          BoxShadow(
                            color: _roomPurple.withOpacity(.55),
                            blurRadius: 18,
                          ),
                        ]
                      : null,
                ),
                child: name == null
                    ? const Icon(Icons.add_rounded, color: _roomGold, size: 24)
                    : const Icon(Icons.person_rounded,
                        color: _roomGold, size: 29),
              ),
              const SizedBox(height: 4),
              Text(
                name ?? 'No.${index + 1}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance',
                      style: TextStyle(color: _C.muted, fontSize: 14)),
                  SizedBox(height: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: testerCoinBalance,
                    builder: (_, coins, __) => Row(
                      children: [
                        const Icon(Icons.monetization_on_rounded,
                            color: _C.gold, size: 31),
                        const SizedBox(width: 10),
                        Text(
                          _formatCoins(coins),
                          style: const TextStyle(
                            color: _C.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  ValueListenableBuilder<int>(
                    valueListenable: testerDiamondBalance,
                    builder: (_, diamonds, __) => Row(
                      children: [
                        const Icon(Icons.diamond_rounded,
                            color: Color(0xFF4B94D8), size: 27),
                        const SizedBox(width: 10),
                        Text(
                          _formatCoins(diamonds),
                          style: const TextStyle(
                            color: _C.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
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
                _WalletAction(Icons.card_giftcard_rounded, 'Gift Code', () {
                  _showTestingGiftCode(context);
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

void _showTestingGiftCode(BuildContext context) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Gift Code'),
      content: TextField(controller: controller, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(hintText: 'Contoh: TEST100K')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
        FilledButton(
          onPressed: () {
            final code = controller.text.trim().toUpperCase();
            final amount = code == 'TEST100K' ? 100000 : code == 'TEST1M' ? 1000000 : 0;
            if (amount == 0) {
              _showMessage(context, 'Kode testing: TEST100K atau TEST1M');
              return;
            }
            _rechargeForTesting(amount);
            Navigator.pop(dialogContext);
            _showMessage(context, 'Gift Code berhasil: +${_formatCoins(amount)} Coin.');
          },
          child: const Text('Redeem'),
        ),
      ],
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

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _items = <_ChatItem>[
    _ChatItem('Nana', 'Kamu on malam ini? 😍', '2m', 3),
    _ChatItem('Raka', 'Voice call?', '10m', 0),
    _ChatItem('Salsa', 'Oke deh, sampai nanti!', '1h', 0),
    _ChatItem('Dimas', 'Mantap!', '2h', 0),
    _ChatItem('Official Cuan Party', 'Event baru sudah hadir!', '3h', 0),
    _ChatItem('System', 'Your Coins have been updated', '1d', 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.text,
        title: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMessage(context, 'Chat options'),
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _C.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Messages'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showMessage(context, 'Friends'),
                  child: const Text('Friends'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LuxuryCard(
                onTap: () => _showMessage(context, 'Open chat with ${item.name}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
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
                            style: const TextStyle(
                              color: _C.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.time,
                          style: const TextStyle(
                            color: _C.muted,
                            fontSize: 11,
                          ),
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
    );
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
