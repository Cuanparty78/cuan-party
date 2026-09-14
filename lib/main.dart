import 'package:flutter/material.dart';

void main() {
  runApp(const CuanPartyApp());
}

class CuanPartyApp extends StatelessWidget {
  const CuanPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CUAN PARTY',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090909),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.dark,
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

  void _handleLogin() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor HP Anda'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  void _handleRegister() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor HP Anda'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Silahkan masuk.'),
            backgroundColor: Colors.green,
          ),
        );
        _phoneController.clear();
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1410),
              const Color(0xFF0f0d0a),
              const Color(0xFF0d0a07),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo & Brand
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFD4AF37).withOpacity(0.3),
                        const Color(0xFFD4AF37).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    size: 60,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                const Text(
                  'CUAN PARTY',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Color(0xFFD4AF37),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 12,
                        color: Color(0xFFD4AF37),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'CONNECT • PARTY • EARN',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2.5,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 56),
                // Phone Input
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1a1410).withOpacity(0.8),
                        const Color(0xFF0f0d0a).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor HP',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.phone_rounded,
                          color: Color(0xFFD4AF37),
                          size: 22,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Login Button
                AnimatedOpacity(
                  opacity: _isLoading ? 0.6 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFD4AF37),
                          const Color(0xFFC19A1B),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                          color: const Color(0xFFD4AF37).withOpacity(0.4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _handleLogin,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF090909),
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'MASUK',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: Color(0xFF090909),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Register Button
                AnimatedOpacity(
                  opacity: _isLoading ? 0.6 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _handleRegister,
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Text(
                            'DAFTAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Bottom Info
                Column(
                  children: [
                    Text(
                      'Dengan masuk, Anda menyetujui',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Syarat & Ketentuan',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFFD4AF37),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          ' dan ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          'Kebijakan Privasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFFD4AF37),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        backgroundColor: const Color(0xFF0E0E0E),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white54,
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
            label: 'Party',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Rank',
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
        return const _RankingContent();
      case 4:
        return const _ProfileContent();
      default:
        return const _HomeContent();
    }
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.3),
                    const Color(0xFFD4AF37).withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUAN PARTY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1a1410),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Search Bar
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search room or user...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFFD4AF37),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Banner
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFD4AF37).withOpacity(0.15),
                const Color(0xFFD4AF37).withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🔥 WEEKLY PARTY',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: 12,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Join the Party Tonight!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Limited slots available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        // Popular Rooms Section
        const Text(
          '🔥 Popular Rooms',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildRoomCard(context, 'PARTY MALAM INI', 'Cuan Host', '125'),
        _buildRoomCard(context, 'NIGHT PARTY', 'DJ Cuan', '89'),
        _buildRoomCard(context, 'SANTAI DULU', 'Kak Party', '64'),
        const SizedBox(height: 28),
        // Recommended Section
        const Text(
          '✨ Recommended',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildRoomCard(context, 'CUAN LOUNGE', 'Host Official', '42'),
      ],
    );
  }

  Widget _buildRoomCard(BuildContext context, String title, String host, String users) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.1),
        ),
        color: const Color(0xFF121212),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RoomPage(
                  roomName: title,
                  hostName: host,
                  userCount: users,
                ),
              ),
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.2),
                    const Color(0xFFD4AF37).withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.mic,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              '$host  •  👥 $users',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Color(0xFFD4AF37),
            ),
          ),
        ),
      ),
    );
  }
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
          color: Color(0xFFD4AF37),
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
          color: Color(0xFFD4AF37),
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
          color: Color(0xFFD4AF37),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Color(0xFFD4AF37),
        ),
      ),
    );
  }
}

class RoomPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
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
                          roomName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Host: $hostName',
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
                          color: const Color(0xFF1a1410),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
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
              const Divider(color: Color(0xFF333333), height: 1),
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
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildControlButton(Icons.mic, 'Mic', () {}),
                    _buildControlButton(Icons.chat_bubble, 'Chat', () {}),
                    _buildControlButton(Icons.card_giftcard, 'Gift', () {}),
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
      ),
    );
  }

  Widget _buildSeat(int index) {
    // Seat pertama (index 0) adalah user sendiri, seat lainnya kosong
    bool isYourSeat = index == 0;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isYourSeat
              ? [
                  const Color(0xFFD4AF37).withOpacity(0.3),
                  const Color(0xFFD4AF37).withOpacity(0.1),
                ]
              : [
                  const Color(0xFF1a1410).withOpacity(0.5),
                  const Color(0xFF0f0d0a).withOpacity(0.3),
                ],
        ),
        border: Border.all(
          color: isYourSeat
              ? const Color(0xFFD4AF37)
              : const Color(0xFFD4AF37).withOpacity(0.2),
          width: isYourSeat ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            color: isYourSeat
                ? const Color(0xFFD4AF37)
                : Colors.white30,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            isYourSeat ? 'You' : '',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isExit = false,
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
                    : [
                        const Color(0xFFD4AF37).withOpacity(0.2),
                        const Color(0xFFD4AF37).withOpacity(0.05),
                      ],
              ),
              border: Border.all(
                color: isExit
                    ? Colors.red.withOpacity(0.5)
                    : const Color(0xFFD4AF37).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isExit ? Colors.red : const Color(0xFFD4AF37),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isExit ? Colors.red : const Color(0xFFD4AF37),
            ),
          ),
        ],
      ),
    );
  }
}
