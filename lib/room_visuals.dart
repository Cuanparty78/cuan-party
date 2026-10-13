import 'dart:math' as math;
import 'package:flutter/material.dart';

class RoomThemePreset {
  const RoomThemePreset(this.id, this.name, this.colors);
  final String id, name;
  final List<Color> colors;
  static const all = [
    RoomThemePreset('purple', 'Purple Night', [Color(0xFF35115C), Color(0xFF080D32)]),
    RoomThemePreset('royal', 'Royal Gold', [Color(0xFF69472D), Color(0xFF170E0A)]),
    RoomThemePreset('ocean', 'Ocean Blue', [Color(0xFF125B79), Color(0xFF061D36)]),
    RoomThemePreset('emerald', 'Emerald Palace', [Color(0xFF185C47), Color(0xFF041F1B)]),
    RoomThemePreset('rose', 'Rose Kingdom', [Color(0xFF803653), Color(0xFF250D26)]),
  ];
  static RoomThemePreset fromId(String id) => all.firstWhere((t) => t.id == id, orElse: () => all.first);
}

class RoomAnnouncement extends StatelessWidget {
  const RoomAnnouncement({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.black.withValues(alpha: .24), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: .1))),
    child: Text(text, textAlign: TextAlign.left, style: const TextStyle(color: Color(0xFFFFD66B), fontWeight: FontWeight.w800, height: 1.45)),
  );
}

class AnimatedSeatEmoji extends StatefulWidget {
  const AnimatedSeatEmoji({super.key, required this.emoji});
  final String emoji;
  @override
  State<AnimatedSeatEmoji> createState() => _AnimatedSeatEmojiState();
}
class _AnimatedSeatEmojiState extends State<AnimatedSeatEmoji> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) { controller.stop(); controller.value = .5; }
    else { controller.repeat(reverse: true); }
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller, builder: (_, child) {
    final wave = math.sin(controller.value * math.pi * 2);
    return Transform.translate(offset: Offset(0, wave * 3), child: Transform.rotate(angle: wave * .12, child: Transform.scale(scale: .9 + controller.value * .17, child: child)));
  }, child: Text(widget.emoji, style: const TextStyle(fontSize: 34)));
}

class SeatActionMenu extends StatelessWidget {
  const SeatActionMenu({super.key, required this.number, required this.locked, required this.canManage, required this.onSeat, required this.onInvite, required this.onLock});
  final int number;
  final bool locked, canManage;
  final VoidCallback onSeat, onInvite, onLock;
  @override
  Widget build(BuildContext context) => Theme(data: Theme.of(context).copyWith(
    brightness: Brightness.light, colorScheme: const ColorScheme.light(primary: Color(0xFF69472D)),
    listTileTheme: const ListTileThemeData(textColor: Color(0xFF422919), iconColor: Color(0xFF69472D)),
  ), child: SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const SizedBox(height: 14), Text('Kursi No.$number', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
    ListTile(leading: const Icon(Icons.event_seat_rounded), title: const Text('Seat'), subtitle: locked ? const Text('Kursi sedang dikunci') : null, enabled: !locked, onTap: locked ? null : onSeat),
    if (canManage) ...[
      ListTile(leading: const Icon(Icons.person_add_alt_1_rounded), title: const Text('Invite user'), enabled: !locked, onTap: locked ? null : onInvite),
      ListTile(leading: Icon(locked ? Icons.lock_open_rounded : Icons.lock_rounded), title: Text(locked ? 'Open seat' : 'Lock seat'), onTap: onLock),
    ],
  ])));
}
