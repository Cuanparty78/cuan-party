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
      backgroundColor: _RoyalTheme.bg,
      body: SafeArea(child: _buildPage(_currentIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: _RoyalTheme.navGradient,
          border: Border(
            top: BorderSide(color: _RoyalTheme.purple.withOpacity(.55)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups_rounded),
              label: 'Family',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const _RoyalHomeContent();
      case 1:
        return const _MessageUpgradePage();
      case 2:
        return const _FamilyUpgradePage();
      case 3:
        return const _ProfileUpgradePage();
      default:
        return const _RoyalHomeContent();
    }
  }
}

class _RoyalTheme {
  static const bg = Color(0xFF09051D);
  static const panel = Color(0xFF15102D);
  static const panel2 = Color(0xFF201541);
  static const purple = Color(0xFF8C4DFF);
  static const purple2 = Color(0xFFB46CFF);
  static const gold = Color(0xFFFFD77A);
  static const gold2 = Color(0xFFFFB84D);
  static const text = Color(0xFFF8F4FF);
  static const muted = Color(0xFFA9A0BF);

  static const navGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF24104F), Color(0xFF10072B)],
  );

  static BoxDecoration panelDecoration({bool glow = false}) => BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: purple.withOpacity(.18)),
        boxShadow: glow
            ? [BoxShadow(color: purple.withOpacity(.18), blurRadius: 18)]
            : null,
      );
}

class _RoyalHomeContent extends StatefulWidget {
  const _RoyalHomeContent();

  @override
  State<_RoyalHomeContent> createState() => _RoyalHomeContentState();
}

class _RoyalHomeContentState extends State<_RoyalHomeContent> {
  final PageController _bannerController = PageController();
  int bannerIndex = 0;
  int tabIndex = 0;

  final banners = const [
    ('REAL VOICES', 'Find your people', Icons.graphic_eq_rounded),
    ('VIP BENEFITS', 'Unlock your royal style', Icons.workspace_premium_rounded),
    ('LIVE ROOMS', 'Join a conversation', Icons.mic_rounded),
    ('FAMILY', 'Build your circle', Icons.groups_rounded),
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF24104F), _RoyalTheme.bg, _RoyalTheme.bg],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 26),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: _RoyalTheme.gold,
                child: Icon(Icons.person, color: _RoyalTheme.bg),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good evening 👋',
                        style: TextStyle(color: _RoyalTheme.muted, fontSize: 11)),
                    SizedBox(height: 2),
                    Text('CUAN PARTY',
                        style: TextStyle(
                          color: _RoyalTheme.text,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        )),
                  ],
                ),
              ),
              _royalIconButton(Icons.search_rounded, () {}),
              const SizedBox(width: 8),
              _royalIconButton(Icons.notifications_none_rounded, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const _MessageV2Page()),
                );
              }),
            ],
          ),
          const SizedBox(height: 17),
          Container(
            height: 43,
            decoration: _RoyalTheme.panelDecoration(),
            child: const TextField(
              style: TextStyle(color: _RoyalTheme.text),
              decoration: InputDecoration(
                hintText: 'Search rooms, people or family',
                hintStyle: TextStyle(color: _RoyalTheme.muted, fontSize: 12),
                prefixIcon: Icon(Icons.search, color: _RoyalTheme.purple2),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 184,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => bannerIndex = i),
              itemBuilder: (_, i) {
                final b = banners[i];
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        _RoyalTheme.purple.withOpacity(.92),
                        _RoyalTheme.panel2,
                        const Color(0xFF3A1B69),
                      ],
                    ),
                    border: Border.all(color: _RoyalTheme.gold.withOpacity(.42)),
                    boxShadow: [
                      BoxShadow(
                        color: _RoyalTheme.purple.withOpacity(.22),
                        blurRadius: 22,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.$1,
                                style: const TextStyle(
                                  color: _RoyalTheme.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                )),
                            const SizedBox(height: 7),
                            Text(b.$2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                )),
                            const SizedBox(height: 7),
                            const Text(
                              'Discover people, rooms and moments.',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 126,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withOpacity(.08),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Icon(b.$3, size: 50, color: _RoyalTheme.gold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == bannerIndex ? 20 : 6,
                height: 5,
                decoration: BoxDecoration(
                  color: i == bannerIndex ? _RoyalTheme.gold : Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _homeTab('MINE', 0),
              _homeTab('HOT', 1),
              _homeTab('DISCOVER', 2),
            ],
          ),
          const SizedBox(height: 14),
          if (tabIndex == 0) _mineHome(context),
          if (tabIndex == 1) _hotHome(context),
          if (tabIndex == 2) _discoverHome(context),
        ],
      ),
    );
  }

  Widget _homeTab(String title, int index) {
    final selected = tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabIndex = index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(
                    color: selected ? _RoyalTheme.gold : _RoyalTheme.muted,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  )),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: selected ? 42 : 0,
                color: _RoyalTheme.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mineHome(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(child: _featureCard('CP', Icons.people_alt_rounded, const Color(0xFF6C35C9), () {})),
              const SizedBox(width: 9),
              Expanded(child: _featureCard('Family', Icons.groups_rounded, const Color(0xFF2474C7), () {
                _open(context, const _FamilyV2Content());
              })),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(child: _featureCard('Rank', Icons.emoji_events_rounded, const Color(0xFF9C6720), () {
                _open(context, const MyRankingPage());
              })),
              const SizedBox(width: 9),
              Expanded(child: _featureCard('User Rank', Icons.person_rounded, const Color(0xFF5C3AA7), () {
                _open(context, const MyRankingPage());
              })),
            ],
          ),
          const SizedBox(height: 14),
          _homeSectionTitle('Live Voice Rooms'),
          const SizedBox(height: 9),
          _roomPreview(context, 'Royal Lounge', '2.5K online', Icons.auto_awesome),
          _roomPreview(context, 'Sweet Talk', '1.8K online', Icons.favorite),
          _roomPreview(context, 'Night Talk', '2.1K online', Icons.mic_rounded),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _open(context, const _PartyV2Content()),
            icon: const Icon(Icons.meeting_room_rounded),
            label: const Text('See All Rooms'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _RoyalTheme.gold,
              side: BorderSide(color: _RoyalTheme.gold.withOpacity(.4)),
            ),
          ),
        ],
      );

  Widget _hotHome(BuildContext context) => Column(
        children: [
          _homeSectionTitle('Hot Now'),
          const SizedBox(height: 9),
          _postPreview('CICI BIGBOSS', 'Sent 50,000 gifts', Icons.card_giftcard, '🔥 8'),
          _postPreview('GARRA', 'Joined Royal Lounge', Icons.meeting_room, '🔥 6'),
          _postPreview('QueenA', 'Reached VIP level', Icons.workspace_premium, '🔥 12'),
        ],
      );

  Widget _discoverHome(BuildContext context) => Column(
        children: [
          _homeSectionTitle('Discover'),
          const SizedBox(height: 9),
          _featureCardWide('Family Rank', 'See active families', Icons.groups_rounded, const Color(0xFF2568B7)),
          _featureCardWide('CP Rank', 'See community ranking', Icons.people_alt_rounded, const Color(0xFF6530A7)),
          _featureCardWide('User Rank', 'See top users', Icons.emoji_events_rounded, const Color(0xFF9B6422)),
          _featureCardWide('Events', 'Explore current events', Icons.event_rounded, const Color(0xFF7C2E72)),
        ],
      );

  Widget _homeSectionTitle(String title) => Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
              color: _RoyalTheme.text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            )),
      );

  Widget _featureCard(String title, IconData icon, Color color, VoidCallback tap) =>
      GestureDetector(
        onTap: tap,
        child: Container(
          height: 104,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(.95), _RoyalTheme.panel],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 25),
              Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  )),
            ],
          ),
        ),
      );

  Widget _featureCardWide(String title, String subtitle, IconData icon, Color color) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(.8), _RoyalTheme.panel]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: _RoyalTheme.gold, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      );

  Widget _roomPreview(BuildContext context, String name, String online, IconData icon) =>
      GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RoomPage(
              roomName: name,
              hostName: 'QueenA',
              userCount: online,
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: _RoyalTheme.panelDecoration(),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: _RoyalTheme.gold2,
                child: Icon(icon, color: _RoyalTheme.bg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                          color: _RoyalTheme.text,
                          fontWeight: FontWeight.w900,
                        )),
                    Text(online,
                        style: const TextStyle(
                          color: _RoyalTheme.muted,
                          fontSize: 11,
                        )),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      );

  Widget _postPreview(String name, String sub, IconData icon, String count) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: _RoyalTheme.panelDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _RoyalTheme.purple,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                        color: _RoyalTheme.text,
                        fontWeight: FontWeight.w900,
                      )),
                  Text(sub,
                      style: const TextStyle(
                        color: _RoyalTheme.muted,
                        fontSize: 11,
                      )),
                ],
              ),
            ),
            Text(count,
                style: const TextStyle(
                  color: _RoyalTheme.gold,
                  fontWeight: FontWeight.w900,
                )),
          ],
        ),
      );
}

Widget _royalIconButton(IconData icon, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );


class _MessageUpgradePage extends StatefulWidget {
  const _MessageUpgradePage();
  @override State<_MessageUpgradePage> createState() => _MessageUpgradePageState();
}
class _MessageUpgradePageState extends State<_MessageUpgradePage> {
  final TextEditingController search = TextEditingController();
  bool showSearch = false;
  final List<Map<String,String>> requests = [
    {'name':'RZ','id':'2001002'}, {'name':'ALVINO','id':'2001003'},
  ];
  @override void dispose(){search.dispose(); super.dispose();}
  void findUser(){
    final id=search.text.trim(); if(id.isEmpty)return;
    showModalBottomSheet(context:context, backgroundColor:_RoyalTheme.bg, builder:(_)=>Padding(
      padding:const EdgeInsets.all(20), child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('USER FOUND',style:TextStyle(color:_RoyalTheme.gold,fontWeight:FontWeight.w900)),
        const SizedBox(height:14),
        Row(children:[const CircleAvatar(radius:28,backgroundColor:_RoyalTheme.gold,child:Icon(Icons.person,color:_RoyalTheme.bg)),const SizedBox(width:12),Expanded(child:Text('USER ${id}',style:const TextStyle(color:_RoyalTheme.text,fontSize:17,fontWeight:FontWeight.w900))),]),
        const SizedBox(height:16),Row(children:[Expanded(child:ElevatedButton(onPressed:(){Navigator.pop(context);},child:const Text('MESSAGE'))),const SizedBox(width:10),Expanded(child:OutlinedButton(onPressed:(){Navigator.pop(context);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Friend request sent')));},child:const Text('ADD FRIEND')))])
      ]),));
  }
  @override Widget build(BuildContext context){return _royalScaffold(title:'Message',actions:[IconButton(icon:Icon(showSearch?Icons.close:Icons.search,color:_RoyalTheme.gold),onPressed:()=>setState(()=>showSearch=!showSearch)),IconButton(icon:const Icon(Icons.person_add_alt_1,color:_RoyalTheme.gold),onPressed:()=>showModalBottomSheet(context:context,backgroundColor:_RoyalTheme.bg,builder:(_)=>_FriendRequestsSheet(requests:requests)))],child:ListView(padding:const EdgeInsets.fromLTRB(16,8,16,30),children:[
    if(showSearch)...[Row(children:[Expanded(child:TextField(controller:search,style:const TextStyle(color:_RoyalTheme.text),decoration:const InputDecoration(hintText:'Search ID',hintStyle:TextStyle(color:_RoyalTheme.muted)))),IconButton(onPressed:findUser,icon:const Icon(Icons.search,color:_RoyalTheme.gold))]),const SizedBox(height:12)],
    const Text('Chats',style:TextStyle(color:_RoyalTheme.text,fontSize:18,fontWeight:FontWeight.w900)),const SizedBox(height:8),
    _msg('CICI BIGBOSS','🤔','16 min',76),_msg('MyPakCik','[Image]','Yesterday',0),_msg('MANAGER ID','Kritik dan keluhan diperbolehkan...','Thu',0),_msg('CICI','cek','11-09',0)
  ]);}
  Widget _msg(String n,String p,String t,int u)=>ListTile(contentPadding:const EdgeInsets.symmetric(vertical:3),leading:const CircleAvatar(backgroundColor:_RoyalTheme.purple,child:Icon(Icons.person,color:Colors.white)),title:Text(n,style:const TextStyle(color:_RoyalTheme.text,fontWeight:FontWeight.w900)),subtitle:Text(p,textAlign:TextAlign.left,style:const TextStyle(color:_RoyalTheme.muted)),trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(t,style:const TextStyle(color:_RoyalTheme.muted,fontSize:10)),if(u>0)Text('$u',style:const TextStyle(color:_RoyalTheme.gold,fontWeight:FontWeight.w900))]));
}
class _FriendRequestsSheet extends StatelessWidget{
 final List<Map<String,String>> requests; const _FriendRequestsSheet({required this.requests});
 @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.all(18),child:ListView(shrinkWrap:true,children:[const Text('Friend Requests',style:TextStyle(color:_RoyalTheme.text,fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:12),...requests.map((r)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(12),decoration:_RoyalTheme.panelDecoration(),child:Row(children:[const CircleAvatar(backgroundColor:_RoyalTheme.gold,child:Icon(Icons.person,color:_RoyalTheme.bg)),const SizedBox(width:10),Expanded(child:Text('${r['name']}\nID ${r['id']}',style:const TextStyle(color:_RoyalTheme.text,fontWeight:FontWeight.w800))),TextButton(onPressed:()=>Navigator.pop(context),child:const Text('TOLAK')),ElevatedButton(onPressed:()=>Navigator.pop(context),child:const Text('TERIMA'))]))) ]));
}
class _FamilyUpgradePage extends StatelessWidget{
 const _FamilyUpgradePage();
 @override Widget build(BuildContext context)=>_royalScaffold(title:'Family',actions:[IconButton(onPressed:()=>_createFamily(context),icon:const Icon(Icons.add_circle_outline,color:_RoyalTheme.gold))],child:ListView(padding:const EdgeInsets.all(16),children:[
   const Text('Family',style:TextStyle(color:_RoyalTheme.text,fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:10),
   _familyCard(context,'ROYAL FAMILY','ID 88001','128 Members',true),_familyCard(context,'GOLDEN VOICE','ID 88002','76 Members',false),_familyCard(context,'CUAN SQUAD','ID 88003','42 Members',false)
 ]));
 Widget _familyCard(BuildContext c,String n,String id,String members,bool owner)=>Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(16),decoration:_RoyalTheme.panelDecoration(),child:Row(children:[const CircleAvatar(radius:30,backgroundColor:_RoyalTheme.gold,child:Icon(Icons.groups,color:_RoyalTheme.bg,size:30)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(n,style:const TextStyle(color:_RoyalTheme.text,fontSize:17,fontWeight:FontWeight.w900)),Text('$id • $members',style:const TextStyle(color:_RoyalTheme.muted))])),ElevatedButton(onPressed:()=>_familyDetail(c,n,owner),child:Text(owner?'OPEN':'JOIN'))]));
 void _createFamily(BuildContext c){showDialog(context:c,builder:(_)=>AlertDialog(backgroundColor:_RoyalTheme.bg,title:const Text('Buat Family',style:TextStyle(color:_RoyalTheme.text)),content:const Text('Isi nama, foto, dan announcement Family.',style:TextStyle(color:_RoyalTheme.muted)),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('CANCEL')),ElevatedButton(onPressed:()=>Navigator.pop(c),child:const Text('SAVE'))]);}
 void _familyDetail(BuildContext c,String n,bool owner){showModalBottomSheet(context:c,backgroundColor:_RoyalTheme.bg,isScrollControlled:true,builder:(_)=>Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(n,style:const TextStyle(color:_RoyalTheme.text,fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:6),const Text('Announcement Family • Weekly & Monthly Trophy',style:TextStyle(color:_RoyalTheme.muted)),const SizedBox(height:18),Row(children:[Expanded(child:ElevatedButton(onPressed:()=>Navigator.pop(c),child:const Text('JOIN FAMILY'))),const SizedBox(width:10),Expanded(child:OutlinedButton(onPressed:()=>Navigator.pop(c),child:Text(owner?'SETTING':'TROPHY')))]),const SizedBox(height:12)]));}
}
class _ProfileUpgradePage extends StatelessWidget{
 const _ProfileUpgradePage();
 void open(BuildContext c,Widget p)=>Navigator.push(c,MaterialPageRoute(builder:(_)=>p));
 @override Widget build(BuildContext c)=>_royalScaffold(title:'Profile',child:ListView(padding:const EdgeInsets.all(16),children:[Container(padding:const EdgeInsets.all(18),decoration:_RoyalTheme.panelDecoration(),child:const Row(children:[CircleAvatar(radius:36,backgroundColor:_RoyalTheme.gold,child:Icon(Icons.person,size:38,color:_RoyalTheme.bg)),SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('CUAN USER',style:TextStyle(color:_RoyalTheme.text,fontSize:20,fontWeight:FontWeight.w900)),Text('ID 1000001',style:TextStyle(color:_RoyalTheme.muted))]))])),const SizedBox(height:14),Wrap(spacing:8,runSpacing:8,children:[_tile(c,'Wallet',Icons.account_balance_wallet,()=>open(c,const WalletV2Page())),_tile(c,'Level',Icons.auto_awesome,()=>open(c,const LevelV2Page())),_tile(c,'Badge',Icons.badge,(){}),_tile(c,'VIP',Icons.workspace_premium,()=>open(c,const VipV2Page())),_tile(c,'SVIP',Icons.diamond,()=>open(c,const SVipV2Page())),_tile(c,'Bag',Icons.inventory_2,()=>open(c,const InventoryV2Page())),_tile(c,'Store',Icons.storefront,()=>open(c,const StoreV2Page())),_tile(c,'CP',Icons.people,(){}),]),const SizedBox(height:16),_row('Invite Friends',Icons.person_add_alt_1,(){}),_row('Settings',Icons.settings,()=>open(c,const SettingsPage()))]));
 Widget _tile(BuildContext c,String t,IconData i,VoidCallback f)=>SizedBox(width:((MediaQuery.of(c).size.width-48)/3),height:88,child:InkWell(onTap:f,child:Container(decoration:_RoyalTheme.panelDecoration(),padding:const EdgeInsets.all(10),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(i,color:_RoyalTheme.gold),const SizedBox(height:6),Text(t,style:const TextStyle(color:_RoyalTheme.text,fontWeight:FontWeight.w800))]))));
 Widget _row(String t,IconData i,VoidCallback f)=>ListTile(onTap:f,leading:Icon(i,color:_RoyalTheme.gold),title:Text(t,style:const TextStyle(color:_RoyalTheme.text,fontWeight:FontWeight.w800)),trailing:const Icon(Icons.chevron_right,color:_RoyalTheme.muted));
}
class _MomentV2Page extends StatelessWidget {
  const _MomentV2Page();

  @override
  Widget build(BuildContext context) {
    return _royalScaffold(
      title: 'Moment',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _royalTabs(['Latest', 'Hot', 'Following']),
          const SizedBox(height: 14),
          _momentPost('User', 'Yesterday 22:51:40', '🔥🔥', false),
          _momentPost('V-Jè', 'Yesterday 22:14:03', 'Thanks onyettt 😜', true),
          _momentPost('LEON', 'Yesterday 21:08:11', 'Hello Cuan Party ✨', false),
        ],
      ),
    );
  }

  Widget _momentPost(String name, String time, String text, bool hasImage) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: _RoyalTheme.panelDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: _RoyalTheme.purple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                            color: _RoyalTheme.text,
                            fontWeight: FontWeight.w900,
                          )),
                      Text(time,
                          style: const TextStyle(
                            color: _RoyalTheme.muted,
                            fontSize: 10,
                          )),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _RoyalTheme.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                  ),
                  child: const Text('Follow'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(text,
                style: const TextStyle(
                  color: _RoyalTheme.text,
                  fontWeight: FontWeight.w700,
                )),
            if (hasImage) ...[
              const SizedBox(height: 12),
              Container(
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B2AA4), Color(0xFF1D1238)],
                  ),
                ),
                child: const Center(
                  child: Text('Moment Image',
                      style: TextStyle(
                        color: _RoyalTheme.gold,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      )),
                ),
              ),
            ],
            const SizedBox(height: 13),
            const Divider(color: Colors.white12),
            const Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white60),
                SizedBox(width: 6),
                Text('0', style: TextStyle(color: Colors.white60)),
                SizedBox(width: 25),
                Icon(Icons.chat_bubble_outline, color: Colors.white60),
                SizedBox(width: 6),
                Text('0', style: TextStyle(color: Colors.white60)),
              ],
            ),
          ],
        ),
      );
}

class _MessageV2Page extends StatelessWidget {
  const _MessageV2Page();

  @override
  Widget build(BuildContext context) {
    return _royalScaffold(
      title: 'Messages',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _royalTabs(['Messages', 'Friends']),
          const SizedBox(height: 12),
          _chatItem('Notification', 'Anda telah menerima hadiah Noble...', '2 days ago', Icons.notifications, 0),
          _chatItem('CICI BIGBOSS', '🤔', '16 minutes ago', Icons.workspace_premium, 76),
          _chatItem('MyPakCik', '[Image]', 'Yesterday', Icons.person, 0),
          _chatItem('MANAGER ID', 'Kritik dan keluhan diperbolehkan...', 'Thu', Icons.person, 0),
          _chatItem('CICI', 'cek', '11-09', Icons.person, 0),
        ],
      ),
    );
  }

  Widget _chatItem(String name, String preview, String time, IconData icon, int unread) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: _RoyalTheme.purple,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                        color: _RoyalTheme.text,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 4),
                  Text(preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _RoyalTheme.muted,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time,
                    style: const TextStyle(
                      color: _RoyalTheme.muted,
                      fontSize: 10,
                    )),
                if (unread > 0) ...[
                  const SizedBox(height: 7),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.redAccent,
                    child: Text('$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
}

class _MeV2Page extends StatelessWidget {
  const _MeV2Page();

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return _royalScaffold(
      title: 'Me',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C2BA3), Color(0xFF17102E)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _RoyalTheme.purple.withOpacity(.45)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: _RoyalTheme.gold,
                  child: Icon(Icons.person, size: 40, color: _RoyalTheme.bg),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CUAN USER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(height: 4),
                      Text('ID 1000001',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: _RoyalTheme.panelDecoration(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatMini('36', 'Visitors'),
                _StatMini('8', 'Following'),
                _StatMini('12', 'Followers'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _meFeature('SVIP', Icons.diamond_rounded, () => _open(context, const SVipV2Page()))),
              const SizedBox(width: 9),
              Expanded(child: _meFeature('Level', Icons.auto_awesome, () => _open(context, const LevelV2Page()))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _meFeature('Wallet', Icons.account_balance_wallet_rounded, () => _open(context, const WalletV2Page()))),
              const SizedBox(width: 8),
              Expanded(child: _meFeature('Store', Icons.storefront_rounded, () => _open(context, const StoreV2Page()))),
              const SizedBox(width: 8),
              Expanded(child: _meFeature('Bag', Icons.inventory_2_rounded, () => _open(context, const InventoryV2Page()))),
              const SizedBox(width: 8),
              Expanded(child: _meFeature('Reward', Icons.emoji_events_rounded, () => _open(context, const MyRankingPage()))),
            ],
          ),
          const SizedBox(height: 12),
          _meMenu('Family', Icons.groups_rounded, () => _open(context, const _FamilyV2Content())),
          _meMenu('CP', Icons.people_alt_rounded, () {}),
          _meMenu('Brother & Sister', Icons.diversity_3_rounded, () {}),
          _meMenu('Invite Friends', Icons.person_add_alt_1_rounded, () {}),
          _meMenu('VIP', Icons.workspace_premium_rounded, () => _open(context, const VipV2Page())),
          _meMenu('Settings', Icons.settings_rounded, () => _open(context, const SettingsPage())),
        ],
      ),
    );
  }

  Widget _meFeature(String title, IconData icon, VoidCallback tap) => GestureDetector(
        onTap: tap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3D246E), Color(0xFF17102E)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _RoyalTheme.purple.withOpacity(.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _RoyalTheme.gold, size: 28),
              const SizedBox(height: 6),
              Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  )),
            ],
          ),
        ),
      );

  Widget _meMenu(String title, IconData icon, VoidCallback tap) => GestureDetector(
        onTap: tap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: _RoyalTheme.panelDecoration(),
          child: Row(
            children: [
              Icon(icon, color: _RoyalTheme.purple2),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: _RoyalTheme.text,
                      fontWeight: FontWeight.w800,
                    )),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      );
}

class _StatMini extends StatelessWidget {
  final String value;
  final String label;
  const _StatMini(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                color: _RoyalTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                color: _RoyalTheme.muted,
                fontSize: 10,
              )),
        ],
      );
}

Widget _royalScaffold({required String title, required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF24104F), _RoyalTheme.bg, _RoyalTheme.bg],
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 8),
          child: Row(
            children: [
              Text(title,
                  style: const TextStyle(
                    color: _RoyalTheme.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  )),
              const Spacer(),
              const Icon(Icons.search, color: Colors.white, size: 25),
              const SizedBox(width: 14),
              const Icon(Icons.more_horiz, color: Colors.white70),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    ),
  );
}

Widget _royalTabs(List<String> tabs) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final selected = tab == tabs.first;
          return Container(
            margin: const EdgeInsets.only(right: 26),
            padding: const EdgeInsets.only(bottom: 7),
            decoration: BoxDecoration(
              border: selected
                  ? const Border(bottom: BorderSide(color: _RoyalTheme.gold, width: 2))
                  : null,
            ),
            child: Text(tab,
                style: TextStyle(
                  color: selected ? _RoyalTheme.gold : _RoyalTheme.muted,
                  fontWeight: FontWeight.w900,
                )),
          );
        }).toList(),
      ),
    );


class _ExchangeUpgradePage extends StatefulWidget{const _ExchangeUpgradePage();@override State<_ExchangeUpgradePage> createState()=>_ExchangeUpgradePageState();}
class _ExchangeUpgradePageState extends State<_ExchangeUpgradePage>{final c=TextEditingController(text:'100');bool coinToDiamond=true;@override void dispose(){c.dispose();super.dispose();} @override Widget build(BuildContext x){final v=int.tryParse(c.text)??0;final out=coinToDiamond?v:(v*70~/100);return _royalSubScaffold(context:x,title:'Exchange',child:Padding(padding:const EdgeInsets.all(18),child:Column(children:[Row(children:[Expanded(child:_switch('Coin → Diamond',coinToDiamond,()=>setState(()=>coinToDiamond=true))),Expanded(child:_switch('Diamond → Coin',!coinToDiamond,()=>setState(()=>coinToDiamond=false)))]),const SizedBox(height:20),TextField(controller:c,onChanged:(_)=>setState((){}),keyboardType:TextInputType.number,style:const TextStyle(color:_RoyalTheme.text),decoration:const InputDecoration(labelText:'Amount',labelStyle:TextStyle(color:_RoyalTheme.gold))),const SizedBox(height:18),Text('Receive  $out ${coinToDiamond?'Diamond':'Coin'}',style:const TextStyle(color:_RoyalTheme.gold,fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:20),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.pop(x),child:const Text('CONFIRM EXCHANGE')))])));}Widget _switch(String t,bool a,VoidCallback f)=>TextButton(onPressed:f,child:Text(t,style:TextStyle(color:a?_RoyalTheme.gold:_RoyalTheme.muted,fontWeight:FontWeight.w900)));}
class WalletV2Page extends StatelessWidget {
  const WalletV2Page({super.key});

  final GlobalAppState _appState = GlobalAppState();

  @override
  Widget build(BuildContext context) {
    final balance = _appState.coinBalance.value;
    return _royalSubScaffold(
      context: context,
      title: 'Wallet',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          const Text('My Gold Coins',
              style: TextStyle(color: _RoyalTheme.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.monetization_on_rounded, color: _RoyalTheme.gold, size: 42),
              const SizedBox(width: 8),
              Text(_formatCoins(balance),
                  style: const TextStyle(
                    color: _RoyalTheme.text,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          const SizedBox(height: 17),
          Container(
            height: 130,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF8C4DFF), Color(0xFF34205D)],
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Recharge',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(height: 5),
                      Text('Add coins to your wallet',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _RoyalTheme.gold,
                    foregroundColor: _RoyalTheme.bg,
                  ),
                  child: const Text('Recharge'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _walletAction(Icons.add_circle_outline, 'Recharge', () {})),
              const SizedBox(width: 10),
              Expanded(child: _walletAction(Icons.swap_horiz_rounded, 'Exchange', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ExchangeUpgradePage())))),
              const SizedBox(width: 10),
              Expanded(child: _walletAction(Icons.receipt_long, 'History', () {})),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Transactions',
              style: TextStyle(
                color: _RoyalTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 9),
          ..._appState.transactions.value.take(8).map(
                (tx) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(13),
                  decoration: _RoyalTheme.panelDecoration(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _RoyalTheme.purple.withOpacity(.25),
                        child: Icon(
                          tx.type == 'recharge'
                              ? Icons.add_rounded
                              : Icons.card_giftcard_rounded,
                          color: _RoyalTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.description,
                                style: const TextStyle(
                                  color: _RoyalTheme.text,
                                  fontWeight: FontWeight.w800,
                                )),
                            Text(
                              '${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}',
                              style: const TextStyle(
                                color: _RoyalTheme.muted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('${tx.amount > 0 ? '+' : ''}${tx.amount}',
                          style: TextStyle(
                            color: tx.amount >= 0 ? _RoyalTheme.gold : Colors.redAccent,
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _walletAction(IconData icon, String title, VoidCallback tap) =>
      GestureDetector(
        onTap: tap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: _RoyalTheme.panelDecoration(),
          child: Column(
            children: [
              Icon(icon, color: _RoyalTheme.gold),
              const SizedBox(height: 5),
              Text(title,
                  style: const TextStyle(
                    color: _RoyalTheme.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
        ),
      );
}

String _formatCoins(int value) {
  final s = value.toString();
  final out = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
    out.write(s[i]);
  }
  return out.toString();
}

Widget _royalSubScaffold({required BuildContext context, required String title, required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF24104F), _RoyalTheme.bg, _RoyalTheme.bg],
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 16, 7),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: _RoyalTheme.text,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    )),
              ),
              const Icon(Icons.more_horiz, color: Colors.white70),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    ),
  );
}

class InventoryV2Page extends StatefulWidget {
  const InventoryV2Page({super.key});

  @override
  State<InventoryV2Page> createState() => _InventoryV2PageState();
}

class _InventoryV2PageState extends State<InventoryV2Page> {
  final categories = const ['Frames', 'VIP', 'Entry', 'Chat Bubble', 'Theme'];
  int selected = 0;
  final page = PageController();

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _royalSubScaffold(
      context: context,
      title: 'Bag',
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (i) {
                final active = i == selected;
                return GestureDetector(
                  onTap: () {
                    setState(() => selected = i);
                    page.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    child: Text(categories[i],
                        style: TextStyle(
                          color: active ? _RoyalTheme.gold : _RoyalTheme.text,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: page,
              itemCount: categories.length,
              onPageChanged: (i) => setState(() => selected = i),
              itemBuilder: (_, i) => _bagGrid(categories[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bagGrid(String category) {
    final names = category == 'Frames'
        ? ['Royal Gold', 'BIGBOSS', 'GARRA', 'Ocean Crown', 'VIP5', 'Host']
        : category == 'VIP'
            ? ['VIP 3', 'VIP 4', 'VIP 5', 'VIP 6', 'VIP 7', 'VIP 8']
            : category == 'Entry'
                ? ['Royal Entry', 'Golden Entry', 'Phoenix Entry', 'Diamond Entry']
                : category == 'Chat Bubble'
                    ? ['Gold Bubble', 'Royal Bubble', 'Love Bubble', 'VIP Bubble']
                    : ['Royal Theme', 'Purple Night', 'Gold Palace', 'Ocean'];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      itemCount: names.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .83,
      ),
      itemBuilder: (_, i) => _bagCard(names[i], i == 1),
    );
  }

  Widget _bagCard(String name, bool selected) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF24104F), Color(0xFF0F0921)],
          ),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: selected ? _RoyalTheme.purple2 : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      _RoyalTheme.purple.withOpacity(.65),
                      Colors.black.withOpacity(.25),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome_rounded,
                      size: 58, color: _RoyalTheme.gold),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _RoyalTheme.text,
                  fontWeight: FontWeight.w900,
                )),
            const SizedBox(height: 4),
            Text(selected ? 'EQUIPPED' : 'Expires in 30 days',
                style: TextStyle(
                  color: selected ? _RoyalTheme.gold : _RoyalTheme.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      );
}

class StoreV2Page extends StatefulWidget {
  const StoreV2Page({super.key});

  @override
  State<StoreV2Page> createState() => _StoreV2PageState();
}

class _StoreV2PageState extends State<StoreV2Page> {
  final tabs = const ['Bingkai', 'Kendaraan', 'Dekorasi Profil', 'Efek', 'Tema'];
  int active = 0;

  @override
  Widget build(BuildContext context) {
    return _royalSubScaffold(
      context: context,
      title: 'Store',
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (i) => GestureDetector(
                onTap: () => setState(() => active = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(tabs[i],
                      style: TextStyle(
                        color: i == active ? _RoyalTheme.gold : _RoyalTheme.text,
                        fontWeight: FontWeight.w900,
                      )),
                ),
              )),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 25),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .78,
              ),
              itemBuilder: (_, i) => _storeCard(tabs[active], i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeCard(String type, int index) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF110A26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _RoyalTheme.purple.withOpacity(.4)),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _RoyalTheme.purple2),
                ),
                child: const Text('Days 30',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B2AA4), Color(0xFF100821)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome,
                      color: _RoyalTheme.gold, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('$type ${index + 1}',
                style: const TextStyle(
                  color: _RoyalTheme.text,
                  fontWeight: FontWeight.w900,
                )),
            const SizedBox(height: 4),
            Text('${(index + 1) * 1000000} COIN',
                style: const TextStyle(
                  color: _RoyalTheme.gold,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                )),
          ],
        ),
      );
}

class LevelV2Page extends StatelessWidget {
  const LevelV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _royalSubScaffold(
      context: context,
      title: 'Level',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
        children: [
          _royalTabs(['Wealth', 'Charm', 'Game']),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF30165F), Color(0xFF0E0821)],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: _RoyalTheme.purple.withOpacity(.45)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: _RoyalTheme.gold,
                  child: Icon(Icons.person, color: _RoyalTheme.bg, size: 42),
                ),
                const SizedBox(height: 10),
                const Text('LV 6',
                    style: TextStyle(
                      color: _RoyalTheme.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    )),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text('48,634,875',
                        style: TextStyle(
                          color: _RoyalTheme.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                    const Spacer(),
                    const Text('50,000,000',
                        style: TextStyle(color: _RoyalTheme.muted)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: .972,
                    minHeight: 10,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(_RoyalTheme.gold),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Need 1.36M EXP to upgrade Lv.7',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Wealth Level',
              style: TextStyle(
                color: _RoyalTheme.text,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 9),
          ...[
            'Level 1 - Level 20',
            'Level 21 - Level 40',
            'Level 41 - Level 60',
            'Level 61 - Level 80',
            'Level 81 - Level 100',
            'Level 101 - Level 120',
          ].asMap().entries.map(
                (e) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: _RoyalTheme.panelDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(e.value,
                            style: const TextStyle(
                              color: _RoyalTheme.text,
                              fontWeight: FontWeight.w800,
                            )),
                      ),
                      Icon(Icons.workspace_premium_rounded,
                          color: e.key.isEven ? _RoyalTheme.gold : _RoyalTheme.purple2),
                      const SizedBox(width: 6),
                      Text('LV ${e.key * 20 + 1}',
                          style: const TextStyle(
                            color: _RoyalTheme.text,
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class SVipV2Page extends StatelessWidget {
  const SVipV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _royalSubScaffold(
      context: context,
      title: 'SVIP',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        children: [
          _royalTabs(['SVIP 1', 'SVIP 2', 'SVIP 3', 'SVIP 4']),
          const SizedBox(height: 10),
          Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Color(0xFF5A4B3A), Color(0xFF11131B)],
              ),
              border: Border.all(color: _RoyalTheme.gold.withOpacity(.35)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.diamond_rounded, color: _RoyalTheme.gold, size: 100),
                Text('SVIP 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    )),
                Text('Exclusive privileges designed for you.',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Royal Privileges',
                style: TextStyle(
                  color: _RoyalTheme.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                )),
          ),
          const SizedBox(height: 9),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            childAspectRatio: 1.1,
            children: const [
              _PrivilegeCard(Icons.celebration, 'Special Room Welcome'),
              _PrivilegeCard(Icons.workspace_premium, 'Special Medal'),
              _PrivilegeCard(Icons.auto_awesome, 'Exclusive Frame'),
              _PrivilegeCard(Icons.card_giftcard, 'Royal Gift'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrivilegeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const _PrivilegeCard(this.icon, this.title);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFF192737),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _RoyalTheme.gold, size: 44),
            const SizedBox(height: 9),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _RoyalTheme.text,
                  fontWeight: FontWeight.w800,
                )),
          ],
        ),
      );
}

class VipV2Page extends StatelessWidget {
  const VipV2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _royalSubScaffold(
      context: context,
      title: 'VIP',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        children: [
          _royalTabs(['VIP 3', 'VIP 4', 'VIP 5', 'VIP 6', 'VIP 7']),
          const SizedBox(height: 12),
          Container(
            height: 210,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Color(0xFF7B244F), Color(0xFF2D0B24)],
              ),
              border: Border.all(color: const Color(0xFFFFA8D2).withOpacity(.4)),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text('VIP5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                      )),
                ),
                Icon(Icons.auto_awesome,
                    color: Color(0xFFFFB3D8), size: 100),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text('Royal Privileges 6/6',
                style: TextStyle(
                  color: _RoyalTheme.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                )),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: .86,
            children: const [
              _PrivilegeCard(Icons.workspace_premium, 'Badge'),
              _PrivilegeCard(Icons.auto_awesome, 'Frame'),
              _PrivilegeCard(Icons.text_fields, 'Colored Name'),
              _PrivilegeCard(Icons.credit_card, 'Profile Style'),
              _PrivilegeCard(Icons.login, 'Entry'),
              _PrivilegeCard(Icons.chat, 'Unlimited Messages'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(
                child: Text('180,000,000 / 30 Days',
                    style: TextStyle(
                      color: _RoyalTheme.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    )),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _RoyalTheme.gold,
                  foregroundColor: _RoyalTheme.bg,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Buy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _PartyContent extends StatelessWidget {
  const _PartyV2Content();

  static const ivory = Color(0xFFF7F1E7);
  static const cream = Color(0xFFFFFBF5);
  static const gold = Color(0xFFC8A45D);
  static const goldDark = Color(0xFF9B7637);
  static const brown = Color(0xFF4A3525);
  static const muted = Color(0xFF8B7A68);

  @override
  Widget build(BuildContext context) {
    final rooms = [
      ('Royal Lounge', 'Official Room', '2.5K', Icons.auto_awesome),
      ('Sweet Talk', 'Maya', '1.8K', Icons.favorite_rounded),
      ('Music Zone', 'Dion', '1.2K', Icons.music_note_rounded),
      ('Night Talk', 'QueenA', '2.1K', Icons.mic_rounded),
    ];

    return Container(
      color: ivory,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          const Text('Voice Room',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: brown)),
          const SizedBox(height: 4),
          const Text('Join a room and start talking',
              style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: gold.withOpacity(.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.graphic_eq_rounded, color: goldDark, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Live Voice Rooms',
                      style: TextStyle(color: brown, fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                Icon(Icons.chevron_right_rounded, color: goldDark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...rooms.map((room) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: gold.withOpacity(.17)),
                ),
                child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RoomPage(
                      roomName: room.$1,
                      hostName: room.$2,
                      userCount: room.$3,
                    ),
                  )),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8D2A3), Color(0xFFC39A53)],
                      ),
                    ),
                    child: Icon(room.$4, color: cream),
                  ),
                  title: Text(room.$1,
                      style: const TextStyle(color: brown, fontWeight: FontWeight.w800)),
                  subtitle: Text('${room.$2} • ${room.$3} online',
                      style: const TextStyle(color: muted, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: goldDark),
                ),
              )),
        ],
      ),
    );
  }
}

class _FamilyContent extends StatelessWidget {
  const _FamilyContent();

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
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          const Text('Family',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: brown)),
          const SizedBox(height: 4),
          const Text('Your community, your circle',
              style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEBD6A3), Color(0xFFC69B56)],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: gold.withOpacity(.35)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.groups_rounded, color: cream, size: 38),
                SizedBox(height: 12),
                Text('Royal Family',
                    style: TextStyle(color: cream, fontSize: 22, fontWeight: FontWeight.w900)),
                SizedBox(height: 5),
                Text('128 members • Active today',
                    style: TextStyle(color: Color(0xFFF7EEDF), fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _FamilyAction(icon: Icons.person_add_alt_1_rounded, label: 'Members')),
              const SizedBox(width: 10),
              Expanded(child: _FamilyAction(icon: Icons.emoji_events_rounded, label: 'Ranking')),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Family Activity',
              style: TextStyle(color: brown, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...[
            ('CICI BIGBOSS', 'Sent 50,000 gifts'),
            ('GARRA', 'Joined Royal Lounge'),
            ('QueenA', 'Reached VIP level'),
          ].map((item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: gold.withOpacity(.15)),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFD2AE67),
                    child: Icon(Icons.person_rounded, color: cream),
                  ),
                  title: Text(item.$1,
                      style: const TextStyle(color: brown, fontWeight: FontWeight.w800)),
                  subtitle: Text(item.$2,
                      style: const TextStyle(color: muted, fontSize: 11)),
                ),
              )),
        ],
      ),
    );
  }
}

class _FamilyAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FamilyAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.18)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF9B7637), size: 24),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                color: Color(0xFF4A3525),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              )),
        ],
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
  Widget page;
  switch (item.$2) {
    case 'Inventory / Bag':
      page = const InventoryPage();
      break;
    case 'Frames':
      page = const FramesPage();
      break;
    case 'Badges':
      page = const BadgesPage();
      break;
    case 'VIP / SVIP':
      page = const VipPage();
      break;
    case 'My Ranking':
      page = const MyRankingPage();
      break;
    case 'Settings':
      page = const SettingsPage();
      break;
    default:
      page = const SettingsPage();
  }
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => page),
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
                              color: Color(0xFF8B7A68),
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
                              color: Color(0xFF8B7A68),
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
                                                  color: Color(0xFF4A3525),
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
                                                  color: Color(0xFF8B7A68),
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
                              color: Color(0xFFB9AA98),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B7A68),
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
                              color: Color(0xFF8B7A68),
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
                          color: Color(0xFF8B7A68),
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
                            color: Color(0xFF4A3525),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan jumlah...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8B7A68),
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
                          color: Color(0xFF8B7A68),
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


class _LuxurySubPage extends StatelessWidget {
  final String title;
  final Widget child;

  const _LuxurySubPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E7),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF9B7637)),
        ),
        title: Text(title,
            style: const TextStyle(
              color: Color(0xFF4A3525),
              fontWeight: FontWeight.w900,
            )),
        centerTitle: true,
      ),
      body: child,
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.card_giftcard_rounded, 'Gifts', '18 items'),
      (Icons.auto_awesome_rounded, 'Frames', '4 owned'),
      (Icons.workspace_premium_rounded, 'Badges', '6 owned'),
      (Icons.inventory_2_outlined, 'Other Items', '3 items'),
    ];

    return _LuxurySubPage(
      title: 'Inventory / Bag',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.18)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF2E7D7),
              child: Icon(item.$1, color: const Color(0xFF9B7637)),
            ),
            title: Text(item.$2,
                style: const TextStyle(color: Color(0xFF4A3525), fontWeight: FontWeight.w800)),
            subtitle: Text(item.$3,
                style: const TextStyle(color: Color(0xFF8B7A68), fontSize: 11)),
            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9B7637)),
          ),
        )).toList(),
      ),
    );
  }
}

class FramesPage extends StatefulWidget {
  const FramesPage({super.key});

  @override
  State<FramesPage> createState() => _FramesPageState();
}

class _FramesPageState extends State<FramesPage> {
  int equipped = 0;

  @override
  Widget build(BuildContext context) {
    final frames = [
      ('Royal Gold', Icons.auto_awesome_rounded),
      ('Diamond Crown', Icons.workspace_premium_rounded),
      ('Golden Wings', Icons.flight_rounded),
      ('Luxury Night', Icons.nightlight_round),
    ];

    return _LuxurySubPage(
      title: 'Frames',
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: frames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .9,
        ),
        itemBuilder: (_, index) {
          final selected = equipped == index;
          return GestureDetector(
            onTap: () => setState(() => equipped = index),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFC8A45D)
                      : const Color(0xFFC8A45D).withOpacity(.16),
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEBD6A3), Color(0xFFC39A53)],
                      ),
                      border: Border.all(color: const Color(0xFFC8A45D), width: 3),
                    ),
                    child: Icon(frames[index].$2, color: const Color(0xFFFFFBF5), size: 42),
                  ),
                  const SizedBox(height: 12),
                  Text(frames[index].$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF4A3525),
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 7),
                  Text(selected ? 'EQUIPPED' : 'Tap to equip',
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF9B7637)
                            : const Color(0xFF8B7A68),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      ('VIP Member', Icons.workspace_premium_rounded),
      ('Top Gifter', Icons.card_giftcard_rounded),
      ('Room Star', Icons.star_rounded),
      ('Event Winner', Icons.emoji_events_rounded),
      ('Family Hero', Icons.groups_rounded),
      ('Early User', Icons.bolt_rounded),
    ];

    return _LuxurySubPage(
      title: 'Badges',
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: badges.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.18)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(badges[index].$2, color: const Color(0xFFC8A45D), size: 42),
              const SizedBox(height: 10),
              Text(badges[index].$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4A3525),
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 4),
              const Text('OWNED',
                  style: TextStyle(
                    color: Color(0xFF9B7637),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class VipPage extends StatelessWidget {
  const VipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LuxurySubPage(
      title: 'VIP / SVIP',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEBD6A3), Color(0xFFC69B56)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VIP 3',
                    style: TextStyle(
                      color: Color(0xFFFFFBF5),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 6),
                Text('Current membership',
                    style: TextStyle(color: Color(0xFFF7EEDF), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _VipBenefit(icon: Icons.auto_awesome, text: 'Exclusive VIP badge'),
          _VipBenefit(icon: Icons.card_giftcard, text: 'Special gift access'),
          _VipBenefit(icon: Icons.palette_outlined, text: 'Premium profile style'),
          _VipBenefit(icon: Icons.star_outline, text: 'Priority room presence'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.18)),
            ),
            child: const Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: Color(0xFF9B7637), size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Next: SVIP',
                      style: TextStyle(
                        color: Color(0xFF4A3525),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      )),
                ),
                Icon(Icons.chevron_right_rounded, color: Color(0xFF9B7637)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VipBenefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _VipBenefit({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC8A45D)),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                color: Color(0xFF4A3525),
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }
}

class MyRankingPage extends StatelessWidget {
  const MyRankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ranking = [
      ('CICI BIGBOSS', '82,450,000'),
      ('GARRA', '71,200,000'),
      ('QueenA', '65,900,000'),
      ('CUAN USER', '54,800,000'),
      ('Nana', '49,700,000'),
    ];

    return _LuxurySubPage(
      title: 'My Ranking',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.2)),
            ),
            child: const Column(
              children: [
                Icon(Icons.emoji_events_rounded, color: Color(0xFFC8A45D), size: 48),
                SizedBox(height: 8),
                Text('#28',
                    style: TextStyle(
                      color: Color(0xFF4A3525),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    )),
                Text('Your current ranking',
                    style: TextStyle(color: Color(0xFF8B7A68), fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...ranking.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.14)),
              ),
              child: Row(
                children: [
                  Text('#${i + 1}',
                      style: const TextStyle(
                        color: Color(0xFF9B7637),
                        fontWeight: FontWeight.w900,
                      )),
                  const SizedBox(width: 13),
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor: Color(0xFFD2AE67),
                    child: Icon(Icons.person_rounded, color: Color(0xFFFFFBF5), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.$1,
                        style: const TextStyle(
                          color: Color(0xFF4A3525),
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  Text(item.$2,
                      style: const TextStyle(
                        color: Color(0xFF9B7637),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person_outline_rounded, 'Account'),
      (Icons.notifications_none_rounded, 'Notifications'),
      (Icons.lock_outline_rounded, 'Privacy'),
      (Icons.language_rounded, 'Language'),
      (Icons.info_outline_rounded, 'About'),
    ];

    return _LuxurySubPage(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFC8A45D).withOpacity(.15)),
                ),
                child: ListTile(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.$2} siap digunakan')),
                    );
                  },
                  leading: Icon(item.$1, color: const Color(0xFF9B7637)),
                  title: Text(item.$2,
                      style: const TextStyle(
                        color: Color(0xFF4A3525),
                        fontWeight: FontWeight.w700,
                      )),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF8B7A68)),
                ),
              )),
          const SizedBox(height: 10),
          const Center(
            child: Text('CUAN PARTY • V1',
                style: TextStyle(
                  color: Color(0xFF8B7A68),
                  fontSize: 10,
                  letterSpacing: 1,
                )),
          ),
        ],
      ),
    );
  }
}


class _PartyV2Content extends StatelessWidget {
  const _PartyV2Content();

  @override
  Widget build(BuildContext context) {
    final rooms = [
      ('Royal Lounge', 'Official Room • 2.5K online', Icons.auto_awesome),
      ('Sweet Talk', 'Maya • 1.8K online', Icons.favorite),
      ('Music Zone', 'Dion • 1.2K online', Icons.music_note),
      ('Night Talk', 'QueenA • 2.1K online', Icons.mic_rounded),
    ];
    return _royalScaffold(
      title: 'Voice Room',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _RoyalTheme.panelDecoration(glow: true),
            child: const Row(
              children: [
                Icon(Icons.graphic_eq_rounded, color: _RoyalTheme.gold, size: 35),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Live Voice Rooms',
                      style: TextStyle(
                        color: _RoyalTheme.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      )),
                ),
                Icon(Icons.chevron_right, color: Colors.white54),
              ],
            ),
          ),
          const SizedBox(height: 13),
          ...rooms.map(
            (r) => GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RoomPage(
                    roomName: r.$1,
                    hostName: r.$1 == 'Night Talk' ? 'QueenA' : 'Maya',
                    userCount: r.$2.split('•').last.trim(),
                  ),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: _RoyalTheme.panelDecoration(),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 29,
                      backgroundColor: _RoyalTheme.gold2,
                      child: Icon(r.$3, color: _RoyalTheme.bg, size: 25),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.$1,
                              style: const TextStyle(
                                color: _RoyalTheme.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              )),
                          const SizedBox(height: 4),
                          Text(r.$2,
                              style: const TextStyle(
                                color: _RoyalTheme.muted,
                                fontSize: 11,
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54),
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

class _FamilyV2Content extends StatelessWidget {
  const _FamilyV2Content();

  @override
  Widget build(BuildContext context) {
    return _royalScaffold(
      title: 'Family',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7D49D5), Color(0xFF1B1238)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _RoyalTheme.purple2.withOpacity(.35)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.groups_rounded, color: Colors.white, size: 32),
                SizedBox(height: 16),
                Text('Royal Family',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 5),
                Text('128 members • 28 active today',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _familyAction(Icons.person_add_alt_1, 'Members')),
              const SizedBox(width: 9),
              Expanded(child: _familyAction(Icons.emoji_events, 'Ranking')),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Family Activity',
              style: TextStyle(
                color: _RoyalTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 9),
          _activity('CICI BIGBOSS', 'Sent 50,000 gifts'),
          _activity('GARRA', 'Joined Royal Lounge'),
          _activity('QueenA', 'Reached VIP level'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Invite Friends'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _RoyalTheme.gold,
              side: BorderSide(color: _RoyalTheme.gold.withOpacity(.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _familyAction(IconData icon, String title) => Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: _RoyalTheme.panelDecoration(),
        child: Column(
          children: [
            Icon(icon, color: _RoyalTheme.gold, size: 27),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(
                  color: _RoyalTheme.text,
                  fontWeight: FontWeight.w800,
                )),
          ],
        ),
      );

  Widget _activity(String name, String action) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: _RoyalTheme.panelDecoration(),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: _RoyalTheme.gold2,
              child: Icon(Icons.person, color: _RoyalTheme.bg),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      color: _RoyalTheme.text,
                      fontWeight: FontWeight.w900,
                    )),
                const SizedBox(height: 3),
                Text(action,
                    style: const TextStyle(
                      color: _RoyalTheme.muted,
                      fontSize: 11,
                    )),
              ],
            ),
          ],
        ),
      );
}
