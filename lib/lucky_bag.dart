import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

const _gold = Color(0xFFEACB80);
const _brown = Color(0xFF422919);
String _coins(int n) => n >= 1000000 ? '${n ~/ 1000000}M' : '${n ~/ 1000}k';
String _failure(Object error) {
  if (error is FirebaseFunctionsException) {
    if (error.code == 'not-found') return 'Layanan Lucky Bag belum tersedia.';
    return error.message ?? 'Tidak dapat terhubung ke server.';
  }
  return 'Koneksi terputus. Coba lagi.';
}
Future<void> showLuckyBag(BuildContext context, String roomId) => showModalBottomSheet<void>(
  context: context, isScrollControlled: true, useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) => LuckyBagComposer(roomId: roomId),
);

class LuckyBagComposer extends StatefulWidget {
  const LuckyBagComposer({super.key, required this.roomId, this.onSend});
  final String roomId;
  final Future<void> Function(Map<String, dynamic>)? onSend;
  @override
  State<LuckyBagComposer> createState() => _LuckyBagComposerState();
}
class _LuckyBagComposerState extends State<LuckyBagComposer> {
  int amount = 100000, count = 10, minutes = 0;
  bool sending = false, attempted = false;
  String? error;
  final String operation = '${DateTime.now().microsecondsSinceEpoch}_${Random.secure().nextInt(1 << 32)}';
  Widget choices(String label, List<int> values, int selected, void Function(int) choose, {bool coins = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: _brown, fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 12),
      Row(children: [for (final value in values) Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: OutlinedButton(
          onPressed: attempted ? null : () => setState(() => choose(value)),
          style: OutlinedButton.styleFrom(
            foregroundColor: _brown, disabledForegroundColor: _brown,
            backgroundColor: value == selected ? _gold : const Color(0xFFFFFAEF),
            side: BorderSide(color: value == selected ? const Color(0xFFAD7D28) : _gold, width: value == selected ? 2 : 1),
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(coins ? _coins(value) : '$value', style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      ))]), const SizedBox(height: 23),
    ],
  );
  Future<void> send() async {
    if (sending) return;
    setState(() { sending = true; attempted = true; error = null; });
    try {
      final payload = <String, dynamic>{
        'roomId': widget.roomId, 'amount': amount, 'count': count, 'minutes': minutes, 'transactionId': operation,
      };
      if (widget.onSend != null) {
        await widget.onSend!(payload);
      } else {
        await FirebaseFunctions.instanceFor(region: 'asia-southeast2').httpsCallable('createLuckyBag').call(payload);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => error = _failure(e));
    } finally { if (mounted) setState(() => sending = false); }
  }
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF71502F), _brown]),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      border: Border.all(color: _gold, width: 2),
    ),
    child: SingleChildScrollView(child: Padding(
      padding: EdgeInsets.fromLTRB(18, 12, 18, 18 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [const Icon(Icons.redeem_rounded, color: _gold, size: 32), const SizedBox(width: 10),
          const Text('LUCKY BAG', style: TextStyle(color: _gold, fontSize: 23, fontWeight: FontWeight.w900)),
          const Spacer(), IconButton(onPressed: sending ? null : () => Navigator.pop(context), icon: const Icon(Icons.close, color: _gold)),
        ]), const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFF4DE), borderRadius: BorderRadius.circular(23)), child: Column(children: [
          choices('Total koin', [100000, 500000, 1000000, 5000000], amount, (v) => amount = v, coins: true),
          choices('Jumlah penerima', [10, 20, 40, 60], count, (v) => count = v),
          choices('Countdown (menit)', [0, 1, 3, 5], minutes, (v) => minutes = v),
          const Text('Total koin dibagikan dengan nominal acak. Satu akun dapat klaim sekali.', style: TextStyle(color: _brown, fontSize: 12), textAlign: TextAlign.center),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: sending ? null : send,
            style: FilledButton.styleFrom(backgroundColor: _brown, foregroundColor: _gold, padding: const EdgeInsets.symmetric(vertical: 17)),
            child: Text(sending ? 'MENGIRIM…' : attempted ? 'COBA KIRIM LAGI' : 'KIRIM ${_coins(amount)} KOIN', style: const TextStyle(fontWeight: FontWeight.w900)),
          )),
        ])),
      ]),
    )),
  );
}

class RoomLuckyBags extends StatefulWidget {
  const RoomLuckyBags({super.key, required this.roomId});
  final String roomId;
  @override
  State<RoomLuckyBags> createState() => _RoomLuckyBagsState();
}
class _RoomLuckyBagsState extends State<RoomLuckyBags> {
  Timer? timer;
  String? claiming;
  final Set<String> claimed = {};
  @override
  void initState() { super.initState(); timer = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  Future<void> claim(String bagId) async {
    if (claiming != null) return;
    setState(() => claiming = bagId);
    try {
      final response = await FirebaseFunctions.instanceFor(region: 'asia-southeast2').httpsCallable('claimLuckyBag').call({'roomId': widget.roomId, 'bagId': bagId});
      if (!mounted) return;
      claimed.add(bagId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lucky Bag: +${response.data['amount']} koin')));
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_failure(e)))); }
    finally { if (mounted) setState(() => claiming = null); }
  }
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).collection('luckyBags').where('status', isEqualTo: 'active').limit(20).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox.shrink();
      final bags = snapshot.data!.docs.toList()..sort((a,b) => ((b.data()['opensAt'] as num?)?.toInt() ?? 0).compareTo((a.data()['opensAt'] as num?)?.toInt() ?? 0));
      return SizedBox(height: 58, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), children: [
        for (final bag in bags) Builder(builder: (_) {
          final data = bag.data(), remaining = (((data['opensAt'] as num?)?.toInt() ?? 0) - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
          final done = claimed.contains(bag.id);
          return Padding(padding: const EdgeInsets.only(right: 8), child: FilledButton.icon(
            onPressed: remaining > 0 || done || claiming != null ? null : () => claim(bag.id),
            style: FilledButton.styleFrom(backgroundColor: _brown, foregroundColor: _gold, disabledBackgroundColor: _brown, disabledForegroundColor: _gold, side: const BorderSide(color: _gold)),
            icon: const Icon(Icons.redeem_rounded),
            label: Text('${data['senderName'] ?? 'User'} · ${_coins((data['amount'] as num).toInt())}\n${done ? 'SUDAH DIKLAIM' : remaining > 0 ? 'BUKA DALAM ${remaining}s' : claiming == bag.id ? 'MENGKLAIM…' : 'KLAIM LUCKY BAG'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
          ));
        }),
      ]));
    },
  );
}
