import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cuan_party/lucky_bag.dart';

void main() {
  testWidgets('Lucky Bag retries preserve the coin pool and transaction identity', (tester) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final payloads = <Map<String, dynamic>>[];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LuckyBagComposer(roomId: 'royal', onSend: (data) async {
      payloads.add(Map.of(data));
      throw Exception('connection lost');
    }))));
    await tester.tap(find.text('5M'));
    await tester.tap(find.text('60'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('KIRIM 5M KOIN'));
    await tester.pumpAndSettle();
    expect(payloads.single['amount'], 5000000);
    expect(payloads.single['count'], 60);
    expect(payloads.single['minutes'], 5);
    await tester.tap(find.text('100k')); // Selection remains locked for this operation.
    await tester.tap(find.text('COBA KIRIM LAGI'));
    await tester.pumpAndSettle();
    expect(payloads.length, 2);
    expect(payloads[1], payloads[0]);
  });
}
