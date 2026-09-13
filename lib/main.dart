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
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_rounded, size: 76, color: Color(0xFFD4AF37)),
            SizedBox(height: 18),
            Text(
              'CUAN PARTY',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'CONNECT • PARTY • EARN',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: Colors.white54,
              ),
            ),
          ],
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
  int index = 0;

  final pages = const [
    _HomeContent(),
    _PartyContent(),
    _InboxContent(),
    _RankingContent(),
    _ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0E0E0E),
        indicatorColor: const Color(0xFF332B13),
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.mic_none), selectedIcon: Icon(Icons.mic), label: 'Party'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'Rank'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 21,
              backgroundColor: Color(0xFF2A2413),
              child: Icon(Icons.person, color: Color(0xFFD4AF37)),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('CUAN PARTY', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            ),
            _iconButton(Icons.diamond_outlined),
            const SizedBox(width: 4),
            _iconButton(Icons.notifications_none),
          ],
        ),
        const SizedBox(height: 18),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search room or user...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color(0xFF151515),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF241D0B), Color(0xFF110F0A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFF6E5B22)),
          ),
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WEEKLY PARTY', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              Spacer(),
              Text('Join the party', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text('Event banner • server controlled', style: TextStyle(color: Colors.white60)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle(title: '🔥 Popular Rooms'),
        const SizedBox(height: 10),
        const _RoomCard(title: 'PARTY MALAM INI', host: 'Cuan Host', users: '125'),
        const _RoomCard(title: 'NIGHT PARTY', host: 'DJ Cuan', users: '89'),
        const _RoomCard(title: 'SANTAI DULU', host: 'Kak Party', users: '64'),
        const SizedBox(height: 18),
        const _SectionTitle(title: 'Recommended'),
        const SizedBox(height: 10),
        const _RoomCard(title: 'CUAN LOUNGE', host: 'Host Official', users: '42'),
      ],
    );
  }

  static Widget _iconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, size: 21, color: const Color(0xFFD4AF37)),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String title;
  final String host;
  final String users;

  const _RoomCard({required this.title, required this.host, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF121212),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF2A2413),
          child: Icon(Icons.mic, color: Color(0xFFD4AF37)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$host  •  👥 $users'),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFD4AF37)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomPage()));
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800));
}

class _PartyContent extends StatelessWidget {
  const _PartyContent();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Party Discovery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)));
}

class _InboxContent extends StatelessWidget {
  const _InboxContent();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Inbox', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)));
}

class _RankingContent extends StatelessWidget {
  const _RankingContent();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Ranking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)));
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)));
}

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PARTY MALAM INI'),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Text('ROOM LEVEL 8', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF2A2413),
            child: Icon(Icons.person, size: 45, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 8),
          const Text('👑 Cuan Host', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Seat(),
              _Seat(),
              _Seat(active: true),
              _Seat(),
              _Seat(),
            ],
          ),
          const Spacer(),
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0E0E0E),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💬 Chat', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 14),
                Text('Welcome to the party!'),
                SizedBox(height: 8),
                Text('🔥🔥🔥'),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _action(Icons.chat_bubble_outline, 'Chat'),
                  _action(Icons.card_giftcard, 'Gift'),
                  _action(Icons.favorite_border, 'React'),
                  _action(Icons.mic_none, 'Mic'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _action(IconData icon, String label) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [Icon(icon, color: const Color(0xFFD4AF37)), const SizedBox(height: 3), Text(label, style: const TextStyle(fontSize: 11))],
  );
}

class _Seat extends StatelessWidget {
  final bool active;
  const _Seat({this.active = false});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CircleAvatar(
        radius: 25,
        backgroundColor: active ? const Color(0xFF5B4A18) : const Color(0xFF1C1C1C),
        child: Icon(active ? Icons.mic : Icons.person_outline, color: active ? const Color(0xFFD4AF37) : Colors.white54),
      ),
      const SizedBox(height: 5),
      const Text('Seat', style: TextStyle(fontSize: 10, color: Colors.white60)),
    ],
  );
}
