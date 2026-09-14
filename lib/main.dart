import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CuanPartyApp());
}

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
            // Wallet Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WalletPage(),
                  ),
                );
              },
              child: Container(
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
                  Icons.wallet_rounded,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
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
        // COIN Balance Card (Tap to open Wallet)
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const WalletPage(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFD4AF37).withOpacity(0.2),
                  const Color(0xFFD4AF37).withOpacity(0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Balance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '💰 100,000,000 COIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD4AF37),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFD4AF37).withOpacity(0.3),
                        const Color(0xFFD4AF37).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                ),
              ],
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
          backgroundColor: const Color(0xFFD4AF37).withOpacity(0.8),
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

  String _getTransactionColor(String type) {
    switch (type) {
      case 'recharge':
        return 'positive';
      case 'gift':
        return 'negative';
      case 'earn':
        return 'positive';
      default:
        return 'neutral';
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
              backgroundColor: const Color(0xFF090909),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1410),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
              title: const Text(
                'My Wallet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Color(0xFFD4AF37),
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
                            const Color(0xFFD4AF37).withOpacity(0.2),
                            const Color(0xFFD4AF37).withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
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
                              color: Color(0xFFD4AF37),
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
                        child: const Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              'RECHARGE COIN',
                              style: TextStyle(
                                fontSize: 15,
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
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Transactions List
                  _transactions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
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
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];
                            final isPositive = transaction.amount > 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withOpacity(0.1),
                                  ),
                                  color: const Color(0xFF121212),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFD4AF37)
                                                .withOpacity(0.15),
                                            const Color(0xFFD4AF37)
                                                .withOpacity(0.05),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFD4AF37)
                                              .withOpacity(0.2),
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
                                    const SizedBox(width: 12),
                                    // Description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction.description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat('dd MMM HH:mm', 'id_ID')
                                                .format(transaction
                                                    .timestamp),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Amount
                                    Text(
                                      '${isPositive ? '+' : ''}${_formatCurrency(transaction.amount)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isPositive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                color: const Color(0xFF0f0d0a),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
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
                              color: Color(0xFFD4AF37),
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
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
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
                                        color: const Color(0xFFD4AF37)
                                            .withOpacity(0.3),
                                      ),
                                      color: const Color(0xFF1a1410),
                                    ),
                                    child: Text(
                                      _formatCurrency(amount),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFD4AF37),
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
                                const Color(0xFFD4AF37),
                                const Color(0xFFC19A1B),
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
                                  color: Color(0xFF090909),
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
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
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
                                  color: Color(0xFFD4AF37),
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
        backgroundColor: const Color(0xFFD4AF37).withOpacity(0.8),
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
                                color: Color(0xFFD4AF37),
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
                    color: const Color(0xFF0f0d0a),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
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
                            color: const Color(0xFF1a1410).withOpacity(0.5),
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
                                                  const Color(0xFFD4AF37).withOpacity(0.3),
                                                  const Color(0xFFD4AF37).withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 14,
                                              color: Color(0xFFD4AF37),
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
                                      color: const Color(0xFFD4AF37).withOpacity(0.3),
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
                                        const Color(0xFFD4AF37),
                                        const Color(0xFFC19A1B),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Color(0xFF090909),
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
                    color: const Color(0xFF0f0d0a),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
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
                                  color: Color(0xFFD4AF37),
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
                          color: Color(0xFF333333),
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
                                          const Color(0xFFD4AF37).withOpacity(0.15),
                                          const Color(0xFFD4AF37).withOpacity(0.05),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFD4AF37)
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
                                            color: Color(0xFFD4AF37),
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
                    const Color(0xFFD4AF37).withOpacity(0.3),
                    const Color(0xFFD4AF37).withOpacity(0.1),
                  ]
                : isSelected
                    ? [
                        const Color(0xFFD4AF37).withOpacity(0.25),
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
                : isSelected
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFD4AF37).withOpacity(0.2),
            width: (isYourSeat || isSelected) ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: isYourSeat || isSelected
                  ? const Color(0xFFD4AF37)
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
                color: Color(0xFFD4AF37),
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
                            const Color(0xFFD4AF37).withOpacity(0.4),
                            const Color(0xFFD4AF37).withOpacity(0.2),
                          ]
                        : [
                            const Color(0xFFD4AF37).withOpacity(0.2),
                            const Color(0xFFD4AF37).withOpacity(0.05),
                          ],
              ),
              border: Border.all(
                color: isExit
                    ? Colors.red.withOpacity(0.5)
                    : isActive
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFFD4AF37).withOpacity(0.3),
                width: isActive ? 2 : 1.5,
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
