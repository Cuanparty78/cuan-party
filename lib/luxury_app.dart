import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Transaction Model
class Transaction {
  final String type; // 'recharge', 'gift', 'earn'
  final int amount;
  final DateTime timestamp;
  final String description;

  Transaction({
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.description,
  });
}

// Global App State
class GlobalAppState {
  static final GlobalAppState _instance = GlobalAppState._internal();
  
  late ValueNotifier<int> coinBalance;
  late ValueNotifier<List<Transaction>> transactions;

  factory GlobalAppState() {
    return _instance;
  }

  GlobalAppState._internal() {
    coinBalance = ValueNotifier(100000000); // 100 juta coin
    transactions = ValueNotifier([
      Transaction(
        type: 'earn',
        amount: 50000,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Earn dari Party MALAM INI',
      ),
      Transaction(
        type: 'gift',
        amount: -100000,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        description: 'Kirim Gift Diamond 💎',
      ),
      Transaction(
        type: 'recharge',
        amount: 500000,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Recharge Coin',
      ),
      Transaction(
        type: 'earn',
        amount: 250000,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        description: 'Earn dari Party NIGHT PARTY',
      ),
      Transaction(
        type: 'gift',
        amount: -50000,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Kirim Gift Rose 🌹',
      ),
    ]);
  }

  void addTransaction(Transaction transaction) {
    final currentList = transactions.value;
    currentList.insert(0, transaction);
    transactions.value = List.from(currentList);
  }

  void updateBalance(int amount) {
    coinBalance.value += amount;
  }
}

class CuanPartyApp extends StatelessWidget {
  const CuanPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CUAN PARTY',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F1E7),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8A45D),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _enterApp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 28, 26, 22),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE9D6A8), Color(0xFFC39A53)],
                  ),
                  border: Border.all(color: const Color(0xFFFFFBF5), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8A45D).withOpacity(.28),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.mic_rounded, size: 48,
                    color: Color(0xFFFFFBF5)),
              ),
              const SizedBox(height: 18),
              const Text(
                'CUAN PARTY',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: Color(0xFF4A3525),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'REAL VOICES  •  REAL PEOPLE',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.8,
                  color: Color(0xFF8B7A68),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'A BETTER YOU',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2.4,
                  color: Color(0xFF9B7637),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 38),
              _socialButton(Icons.g_mobiledata_rounded, 'Continue with Google'),
              if (isIOS) ...[
                const SizedBox(height: 12),
                _socialButton(Icons.apple, 'Continue with Apple'),
              ],
              const SizedBox(height: 12),
              _socialButton(Icons.phone_rounded, 'Continue with Phone'),
              const SizedBox(height: 27),
              Row(
                children: [
                  Expanded(child: Divider(
                      color: const Color(0xFFC8A45D).withOpacity(.35))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or login with',
                        style: TextStyle(
                            color: Color(0xFF8B7A68), fontSize: 11)),
                  ),
                  Expanded(child: Divider(
                      color: const Color(0xFFC8A45D).withOpacity(.35))),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _miniSocial(Icons.facebook),
                  _miniSocial(Icons.music_note_rounded),
                  _miniSocial(Icons.chat_bubble_rounded),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF8B7A68), fontSize: 10, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _enterApp,
        icon: Icon(icon, color: const Color(0xFF4A3525), size: 22),
        label: Text(label,
            style: const TextStyle(
                color: Color(0xFF4A3525), fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBF5),
          side: BorderSide(
              color: const Color(0xFFC8A45D).withOpacity(.45)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _miniSocial(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: _enterApp,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFBF5),
            border: Border.all(
                color: const Color(0xFFC8A45D).withOpacity(.35)),
          ),
          child: Icon(icon, color: const Color(0xFF9B7637), size: 20),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: const Color(0xFFFFFBF5),
        selectedItemColor: const Color(0xFF9B7637),
        unselectedItemColor: const Color(0xFF9A8B7A),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none),
            activeIcon: Icon(Icons.mic),
            label: 'Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const _HomeContent();
      case 1:
        return const _PartyContent();
      case 2:
        return const _InboxContent();
      case 3:
        return const WalletPage();
      case 4:
        return const _ProfileContent();
      default:
        return const _HomeContent();
    }
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  static const ivory = Color(0xFFF7F1E7);
  static const cream = Color(0xFFFFFBF5);
  static const gold = Color(0xFFC8A45D);
  static const goldDark = Color(0xFF9B7637);
  static const brown = Color(0xFF4A3525);
  static const muted = Color(0xFF8B7A68);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ivory,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          _header(context),
          const SizedBox(height: 14),
          _search(),
          const SizedBox(height: 16),
          _heroBanner(),
          const SizedBox(height: 20),
          _quickMenu(context),
          const SizedBox(height: 23),
          _sectionTitle('Recommended Rooms', 'See All'),
          const SizedBox(height: 11),
          _roomRow(context),
          const SizedBox(height: 22),
          _sectionTitle('Live Now', 'See All'),
          const SizedBox(height: 11),
          _roomList(context),
          const SizedBox(height: 22),
          _sectionTitle('Family & Event', 'More'),
          const SizedBox(height: 11),
          _familyEventCards(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
                colors: [Color(0xFFE9D6A8), Color(0xFFC39A53)]),
            border: Border.all(color: cream, width: 2),
            boxShadow: [
              BoxShadow(color: gold.withOpacity(.20), blurRadius: 12)
            ],
          ),
          child: const Icon(Icons.person_rounded, color: cream, size: 24),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good evening 👋',
                  style: TextStyle(color: muted, fontSize: 11)),
              SizedBox(height: 2),
              Text('CUAN PARTY',
                  style: TextStyle(
                      color: brown,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1)),
            ],
          ),
        ),
        _iconButton(Icons.search_rounded, () {}),
        const SizedBox(width: 7),
        _iconButton(Icons.notifications_none_rounded, () {}),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: gold.withOpacity(.25))),
          child: Icon(icon, color: brown, size: 19),
        ),
      );

  Widget _search() => Container(
        height: 46,
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: gold.withOpacity(.22)),
        ),
        child: const TextField(
          style: TextStyle(color: brown),
          decoration: InputDecoration(
            hintText: 'Search rooms, people or family',
            hintStyle: TextStyle(color: muted, fontSize: 12),
            prefixIcon: Icon(Icons.search_rounded, color: goldDark),
            border: InputBorder.none,
          ),
        ),
      );

  Widget _heroBanner() => Container(
        height: 176,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEBD6A3), Color(0xFFC69B56)],
          ),
          border: Border.all(color: const Color(0xFFB68A47).withOpacity(.5)),
          boxShadow: [
            BoxShadow(color: gold.withOpacity(.18), blurRadius: 18, offset: const Offset(0, 7))
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Real Voices',
                      style: TextStyle(
                          color: cream,
                          fontSize: 25,
                          fontWeight: FontWeight.w900)),
                  Text('Real Connections',
                      style: TextStyle(
                          color: cream,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 9),
                  Text('Meet new people. Join a room. Find your circle.',
                      style: TextStyle(
                          color: Color(0xFFF7EEDF),
                          fontSize: 11,
                          height: 1.35)),
                ],
              ),
            ),
            Container(
              width: 92,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: cream.withOpacity(.22),
                border: Border.all(color: cream.withOpacity(.55)),
              ),
              child: const Icon(Icons.graphic_eq_rounded,
                  size: 54, color: cream),
            ),
          ],
        ),
      );

  Widget _quickMenu(BuildContext context) {
    final items = [
      (Icons.mic_none_rounded, 'Popular'),
      (Icons.videogame_asset_rounded, 'Game'),
      (Icons.event_rounded, 'Event'),
      (Icons.emoji_events_rounded, 'Ranking'),
      (Icons.groups_rounded, 'Family'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cream,
                    border: Border.all(color: gold.withOpacity(.28)),
                  ),
                  child: Icon(item.$1, color: goldDark, size: 21),
                ),
                const SizedBox(height: 6),
                Text(item.$2,
                    style: const TextStyle(
                        color: brown,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title, String action) => Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: brown, fontSize: 17, fontWeight: FontWeight.w900)),
          const Spacer(),
          Text(action,
              style: const TextStyle(color: goldDark, fontSize: 11)),
        ],
      );

  Widget _roomRow(BuildContext context) {
    final rooms = [
      ('Royal Lounge', '2.5K', Icons.auto_awesome),
      ('Sweet Talk', '1.8K', Icons.favorite_rounded),
      ('Music Zone', '1.2K', Icons.music_note_rounded),
    ];
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 11),
        itemBuilder: (_, index) {
          final room = rooms[index];
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RoomPage(
                    roomName: room.$1,
                    hostName: 'Official Room',
                    userCount: room.$2),
              ),
            ),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 148,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold.withOpacity(.20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.035),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE8D2A3), Color(0xFFD0AB69)]),
                    ),
                    child: Center(
                        child: Icon(room.$3, color: cream, size: 32)),
                  ),
                  const SizedBox(height: 8),
                  Text(room.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: brown, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text('${room.$2} online',
                      style: const TextStyle(color: muted, fontSize: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roomList(BuildContext context) {
    final rooms = [
      ('Night Talk', 'QueenA', '2.1K'),
      ('Love Corner', 'Nana', '1.8K'),
      ('Chill Room', 'Rizky', '966'),
    ];
    return Column(
      children: rooms.map((room) {
        return Container(
          margin: const EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: gold.withOpacity(.17))),
          child: ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RoomPage(
                  roomName: room.$1,
                  hostName: room.$2,
                  userCount: room.$3),
            )),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                    colors: [Color(0xFFE8D2A3), Color(0xFFC39A53)]),
              ),
              child: const Icon(Icons.mic_rounded, color: cream),
            ),
            title: Text(room.$1,
                style: const TextStyle(
                    color: brown, fontWeight: FontWeight.w800, fontSize: 14)),
            subtitle: Text('${room.$2}  •  ${room.$3} online',
                style: const TextStyle(color: muted, fontSize: 11)),
            trailing: const Icon(Icons.chevron_right_rounded, color: goldDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _familyEventCards() => Row(
        children: [
          Expanded(child: _smallCard(Icons.groups_rounded, 'Family', 'Royal Family')),
          const SizedBox(width: 10),
          Expanded(child: _smallCard(Icons.celebration_rounded, 'Event', 'Voice Star')),
        ],
      );

  Widget _smallCard(IconData icon, String title, String subtitle) => Container(
        height: 92,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: gold.withOpacity(.18))),
        child: Row(
          children: [
            Icon(icon, color: goldDark, size: 28),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: brown, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PartyContent extends StatelessWidget {
  const _PartyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Party Discovery',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color(0xFFC8A45D),
        ),
      ),
    );
  }
}

class _InboxContent extends StatelessWidget {
  const _InboxContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Inbox',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color(0xFFC8A45D),
        ),
      ),
    );
  }
}

class _RankingContent extends StatelessWidget {
  const _RankingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ranking',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color(0xFFC8A45D),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFFFBF5);
    const ivory = Color(0xFFF7F1E7);
    const gold = Color(0xFFC8A45D);
    const brown = Color(0xFF4A3525);
    const muted = Color(0xFF8B7A68);

    final items = [
      (Icons.inventory_2_outlined, 'Inventory / Bag'),
      (Icons.auto_awesome, 'Frames'),
      (Icons.workspace_premium_outlined, 'Badges'),
      (Icons.workspace_premium_rounded, 'VIP / SVIP'),
      (Icons.emoji_events_outlined, 'My Ranking'),
      (Icons.settings_outlined, 'Settings'),
    ];

    return Container(
      color: ivory,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Profile',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w900, color: brown)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: gold.withOpacity(.22)),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 43,
                  backgroundColor: Color(0xFFD2AE67),
                  child: Icon(Icons.person_rounded, color: cream, size: 43),
                ),
                SizedBox(height: 11),
                Text('CUAN USER',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: brown)),
                SizedBox(height: 4),
                Text('ID 1000001',
                    style: TextStyle(color: muted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: gold.withOpacity(.15))),
                child: ListTile(
                  onTap: () {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(item.$2),
      content: const Text('Menu siap digunakan.'),
    ),
  );
},
                  leading: Icon(item.$1, color: const Color(0xFF9B7637)),
                  title: Text(item.$2,
                      style: const TextStyle(
                          color: brown, fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.chevron_right, color: muted),
                ),
              )),
        ],
      ),
    );
  }
}

class RoomPage extends StatefulWidget {
  final String roomName;
  final String hostName;
  final String userCount;

  const RoomPage({
    super.key,
    required this.roomName,
    required this.hostName,
    required this.userCount,
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late int _coinBalance;
  late List<Transaction> _transactions;
  bool _showRechargeModal = false;
  final TextEditingController _rechargeController = TextEditingController();
  final GlobalAppState _appState = GlobalAppState();

  @override
  void initState() {
    super.initState();
    _coinBalance = _appState.coinBalance.value;
    _transactions = _appState.transactions.value;
    
    // Listen to global state changes
    _appState.coinBalance.addListener(_updateBalance);
    _appState.transactions.addListener(_updateTransactions);
  }

  void _updateBalance() {
    if (mounted) {
      setState(() {
        _coinBalance = _appState.coinBalance.value;
      });
    }
  }

  void _updateTransactions() {
    if (mounted) {
      setState(() {
        _transactions = _appState.transactions.value;
      });
    }
  }

  @override
  void dispose() {
    _appState.coinBalance.removeListener(_updateBalance);
    _appState.transactions.removeListener(_updateTransactions);
    _rechargeController.dispose();
    super.dispose();
  }

  void _handleRecharge() {
    final amount = int.tryParse(_rechargeController.text) ?? 0;
    if (amount > 0) {
      _appState.updateBalance(amount);
      _appState.addTransaction(
        Transaction(
          type: 'recharge',
          amount: amount,
          timestamp: DateTime.now(),
          description: 'Recharge Coin',
        ),
      );
      
      setState(() {
        _rechargeController.clear();
        _showRechargeModal = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Recharge ${NumberFormat('#,##0', 'id_ID').format(amount)} Coin'),
          backgroundColor: const Color(0xFFC8A45D).withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatCurrency(int amount) {
    return NumberFormat('#,##0', 'id_ID').format(amount);
  }

  String _getTransactionIcon(String type) {
    switch (type) {
      case 'recharge':
        return '💰';
      case 'gift':
        return '🎁';
      case 'earn':
        return '⭐';
      default:
        return '💱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: const Color(0xFFF7F1E7),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E7D7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFC8A45D).withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFFC8A45D),
                  ),
                ),
              ),
              title: const Text(
                'My Wallet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Color(0xFFC8A45D),
                ),
              ),
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 70,
            ),
            // Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Balance Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFC8A45D).withOpacity(0.2),
                            const Color(0xFFC8A45D).withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFC8A45D).withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '💰 ${_formatCurrency(_coinBalance)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC8A45D),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'COIN',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recharge Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _showRechargeModal = true);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFC8A45D),
                              const Color(0xFF9B7637),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 20,
                              color: const Color(0xFFC8A45D).withOpacity(0.4),
                            ),
                          ],
                        ),
                        child: const Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              'RECHARGE COIN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                color: Color(0xFFF7F1E7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Transaction History Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${_transactions.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFC8A45D),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Transactions List Container dengan Dark Background
                  if (_transactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFFFFBF5),
                          border: Border.all(
                            color: const Color(0xFFC8A45D).withOpacity(0.15),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ..._transactions.asMap().entries.expand((entry) {
                                final index = entry.key;
                                final transaction = entry.value;
                                final isPositive = transaction.amount > 0;
                                final isLast = index == _transactions.length - 1;

                                return [
                                  // Transaction Item
                                  Container(
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? const Color(0xFFFFFBF5)
                                          : const Color(0xFFF2E7D7).withOpacity(0.5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        // Icon Container
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFC8A45D)
                                                    .withOpacity(0.2),
                                                const Color(0xFFC8A45D)
                                                    .withOpacity(0.08),
                                              ],
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFC8A45D)
                                                  .withOpacity(0.25),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getTransactionIcon(
                                                  transaction.type),
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        // Description & Date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transaction.description,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 0.2,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                DateFormat('dd MMM yyyy • HH:mm', 'id_ID')
                                                    .format(transaction.timestamp),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white60,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Amount Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: isPositive
                                                ? Colors.green.withOpacity(0.15)
                                                : Colors.red.withOpacity(0.15),
                                          ),
                                          child: Text(
                                            '${isPositive ? '+' : ''}${_formatCurrency(transaction.amount)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: isPositive
                                                  ? const Color(0xFF4ADE80)
                                                  : const Color(0xFFF87171),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Separator (except for last item)
                                  if (!isLast)
                                    Container(
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 12),
                                      height: 1,
                                      color: const Color(0xFFC8A45D)
                                          .withOpacity(0.08),
                                    ),
                                ];
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFFFFBF5),
                          border: Border.all(
                            color: const Color(0xFFC8A45D).withOpacity(0.15),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: Colors.white30,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      // Recharge Modal
      bottomSheet: _showRechargeModal
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFC8A45D).withOpacity(0.2),
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recharge Coin',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC8A45D),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _showRechargeModal = false);
                              _rechargeController.clear();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white54,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Input Field
                      const Text(
                        'Jumlah Coin',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFC8A45D).withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _rechargeController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan jumlah...',
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '💰',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Quick Amount Buttons
                      const Text(
                        'Quick Select',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          100000,
                          500000,
                          1000000,
                          5000000,
                        ]
                            .map((amount) => GestureDetector(
                                  onTap: () {
                                    _rechargeController.text =
                                        amount.toString();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFC8A45D)
                                            .withOpacity(0.3),
                                      ),
                                      color: const Color(0xFFF2E7D7),
                                    ),
                                    child: Text(
                                      _formatCurrency(amount),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFC8A45D),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Button
                      GestureDetector(
                        onTap: _handleRecharge,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFC8A45D),
                                const Color(0xFF9B7637),
                              ],
                            ),
                          ),
                          child: const Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                'CONFIRM RECHARGE',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: Color(0xFFF7F1E7),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Cancel Button
                      GestureDetector(
                        onTap: () {
                          setState(() => _showRechargeModal = false);
                          _rechargeController.clear();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFC8A45D).withOpacity(0.3),
                            ),
                          ),
                          child: const Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: Color(0xFFC8A45D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _RoomPageState extends State<RoomPage> {
  late TextEditingController _chatController;
  bool _isMicOn = false;
  int? _selectedSeat;
  bool _showChatPanel = false;
  bool _showGiftPanel = false;
  List<String> _messages = [];
  final GlobalAppState _appState = GlobalAppState();

  // Gift data with price in coins
  final List<Map<String, dynamic>> _gifts = [
    {'name': 'Rose 🌹', 'emoji': '🌹', 'price': 10000, 'displayPrice': '10k'},
    {'name': 'Heart ❤️', 'emoji': '❤️', 'price': 25000, 'displayPrice': '25k'},
    {'name': 'Diamond 💎', 'emoji': '💎', 'price': 50000, 'displayPrice': '50k'},
    {'name': 'Ring 💍', 'emoji': '💍', 'price': 100000, 'displayPrice': '100k'},
    {'name': 'Crown 👑', 'emoji': '👑', 'price': 250000, 'displayPrice': '250k'},
    {'name': 'Rocket 🚀', 'emoji': '🚀', 'price': 500000, 'displayPrice': '500k'},
  ];

  @override
  void initState() {
    super.initState();
    _chatController = TextEditingController();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  void _selectSeat(int index) {
    setState(() {
      if (_selectedSeat == index) {
        _selectedSeat = null;
      } else {
        _selectedSeat = index;
      }
    });
  }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _messages.add(_chatController.text);
        _chatController.clear();
      });
    }
  }

  void _sendGift(String giftName, int giftPrice, String giftEmoji) {
    final currentBalance = _appState.coinBalance.value;
    
    // Validasi saldo tidak cukup
    if (currentBalance < giftPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saldo COIN tidak cukup! Diperlukan ${NumberFormat('#,##0', 'id_ID').format(giftPrice)} COIN'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Kurangi saldo
    _appState.updateBalance(-giftPrice);
    
    // Tambahkan transaksi ke history
    _appState.addTransaction(
      Transaction(
        type: 'gift',
        amount: -giftPrice,
        timestamp: DateTime.now(),
        description: 'Kirim Gift $giftName',
      ),
    );
    
    // Tampilkan success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$giftEmoji Terima kasih! Anda mengirim $giftName (-${NumberFormat('#,##0', 'id_ID').format(giftPrice)} COIN)'),
        backgroundColor: const Color(0xFFC8A45D).withOpacity(0.8),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Tutup gift panel TANPA menutup RoomPage
    setState(() {
      _showGiftPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Header dengan tombol keluar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.roomName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFC8A45D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Host: ${widget.hostName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2E7D7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFC8A45D).withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFE1D4C2), height: 1),
                  // Main content area dengan 9 seats
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Grid 3x3 untuk 9 seat
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              children: List.generate(
                                9,
                                (index) => _buildSeat(index),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  // Bottom control buttons
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xFFC8A45D).withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildControlButton(
                          _isMicOn ? Icons.mic : Icons.mic_none,
                          'Mic',
                          _toggleMic,
                          isActive: _isMicOn,
                        ),
                        _buildControlButton(
                          Icons.chat_bubble,
                          'Chat',
                          () {
                            setState(() {
                              _showChatPanel = !_showChatPanel;
                              _showGiftPanel = false;
                            });
                          },
                          isActive: _showChatPanel,
                        ),
                        _buildControlButton(
                          Icons.card_giftcard,
                          'Gift',
                          () {
                            setState(() {
                              _showGiftPanel = !_showGiftPanel;
                              _showChatPanel = false;
                            });
                          },
                          isActive: _showGiftPanel,
                        ),
                        _buildControlButton(
                          Icons.logout,
                          'Keluar',
                          () => Navigator.of(context).pop(),
                          isExit: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Chat Panel
            if (_showChatPanel)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF5),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFC8A45D).withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Chat messages area
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2E7D7).withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: _messages.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Tidak ada pesan',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFFC8A45D).withOpacity(0.3),
                                                  const Color(0xFFC8A45D).withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 14,
                                              color: Color(0xFFC8A45D),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _messages[index],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        // Chat input
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFC8A45D).withOpacity(0.3),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _chatController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Tulis pesan...',
                                      hintStyle: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _sendMessage,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFC8A45D),
                                        const Color(0xFF9B7637),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Color(0xFFF7F1E7),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Gift Panel
            if (_showGiftPanel)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF5),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFC8A45D).withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pilih Gift',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFC8A45D),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showGiftPanel = false;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFE1D4C2),
                          height: 1,
                        ),
                        Container(
                          height: 220,
                          padding: const EdgeInsets.all(12),
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                            children: List.generate(
                              _gifts.length,
                              (index) {
                                final gift = _gifts[index];
                                return GestureDetector(
                                  onTap: () {
                                    _sendGift(
                                      gift['name'],
                                      gift['price'],
                                      gift['emoji'],
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFFC8A45D).withOpacity(0.15),
                                          const Color(0xFFC8A45D).withOpacity(0.05),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFC8A45D)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gift['emoji'],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          gift['displayPrice'],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFFC8A45D),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
  }

  Widget _buildSeat(int index) {
    bool isYourSeat = index == 0;
    bool isSelected = _selectedSeat == index;

    return GestureDetector(
      onTap: () => _selectSeat(index),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isYourSeat
                ? [
                    const Color(0xFFC8A45D).withOpacity(0.3),
                    const Color(0xFFC8A45D).withOpacity(0.1),
                  ]
                : isSelected
                    ? [
                        const Color(0xFFC8A45D).withOpacity(0.25),
                        const Color(0xFFC8A45D).withOpacity(0.1),
                      ]
                    : [
                        const Color(0xFFF2E7D7).withOpacity(0.5),
                        const Color(0xFFFFFBF5).withOpacity(0.3),
                      ],
          ),
          border: Border.all(
            color: isYourSeat
                ? const Color(0xFFC8A45D)
                : isSelected
                    ? const Color(0xFFC8A45D)
                    : const Color(0xFFC8A45D).withOpacity(0.2),
            width: (isYourSeat || isSelected) ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: isYourSeat || isSelected
                  ? const Color(0xFFC8A45D)
                  : Colors.white30,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              isYourSeat
                  ? 'You'
                  : isSelected
                      ? 'Terpilih'
                      : '',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFFC8A45D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isExit = false,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isExit
                    ? [
                        Colors.red.withOpacity(0.3),
                        Colors.red.withOpacity(0.1),
                      ]
                    : isActive
                        ? [
                            const Color(0xFFC8A45D).withOpacity(0.4),
                            const Color(0xFFC8A45D).withOpacity(0.2),
                          ]
                        : [
                            const Color(0xFFC8A45D).withOpacity(0.2),
                            const Color(0xFFC8A45D).withOpacity(0.05),
                          ],
              ),
              border: Border.all(
                color: isExit
                    ? Colors.red.withOpacity(0.5)
                    : isActive
                        ? const Color(0xFFC8A45D)
                        : const Color(0xFFC8A45D).withOpacity(0.3),
                width: isActive ? 2 : 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isExit ? Colors.red : const Color(0xFFC8A45D),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isExit ? Colors.red : const Color(0xFFC8A45D),
            ),
          ),
        ],
      ),
    );
  }
}
