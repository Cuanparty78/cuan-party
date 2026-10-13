import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cuan_party/room_visuals.dart';

void main() {
  testWidgets('announcement keeps full width and aligns left for short and long text', (tester) async {
    for (final text in ['WELCOME', 'Welcome everyone! Let us chat and have fun together.']) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: SizedBox(width: 320, child: RoomAnnouncement(text: text)))));
      expect(tester.widget<Text>(find.text(text)).textAlign, TextAlign.left);
      expect(tester.getSize(find.byType(RoomAnnouncement)).width, 320);
    }
  });
  testWidgets('locked seat exposes Open seat only to managers and cannot be taken', (tester) async {
    var taken = 0, opened = 0;
    Widget menu(bool manage) => MaterialApp(home: Scaffold(body: SeatActionMenu(number: 3, locked: true, canManage: manage,
      onSeat: () => taken++, onInvite: () {}, onLock: () => opened++)));
    await tester.pumpWidget(menu(true));
    expect(find.text('Open seat'), findsOneWidget);
    expect(find.text('Lock seat'), findsNothing);
    await tester.tap(find.text('Seat'));
    expect(taken, 0);
    await tester.tap(find.text('Open seat'));
    expect(opened, 1);
    await tester.pumpWidget(menu(false));
    expect(find.text('Open seat'), findsNothing);
    expect(find.text('Invite user'), findsNothing);
  });
  testWidgets('emoji visibly moves and cleans up its ticker', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AnimatedSeatEmoji(emoji: '😂'))));
    final transforms = find.descendant(of: find.byType(AnimatedSeatEmoji), matching: find.byType(Transform));
    final before = tester.widget<Transform>(transforms.first).transform.storage.toList();
    await tester.pump(const Duration(milliseconds: 180));
    final after = tester.widget<Transform>(transforms.first).transform.storage.toList();
    expect(after, isNot(equals(before)));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
