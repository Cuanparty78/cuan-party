import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cuan_party/profile_photo.dart';

void main() {
  final png = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=');
  test('photos reject non-image data, oversized files and non-HTTPS URLs', () {
    expect(profileImageType(png), 'png');
    expect(profileImageType(Uint8List(4)), null);
    expect(profileImageType(Uint8List(2 * 1024 * 1024 + 1)), null);
    expect(validProfilePhotoUrl('https://example.com/avatar.png'), true);
    for (final url in ['http://example.com/a', 'file:///private/a', 'javascript:alert(1)', 'https://u:p@example.com/a', '']) {
      expect(validProfilePhotoUrl(url), false);
    }
  });
  testWidgets('gallery selection previews photo but does not upload before profile Save', (tester) async {
    Uint8List? selected;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ProfilePhotoPicker(url: '',
      pickGallery: () async => png, onBytes: (value) => selected = value, onUrl: (_) {}))));
    await tester.tap(find.text('Pilih Foto'));
    await tester.pumpAndSettle();
    expect(selected, png);
    expect(tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundImage, isA<MemoryImage>());
    expect(tester.takeException(), isNull);
  });
}
