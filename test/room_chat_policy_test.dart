import 'package:flutter_test/flutter_test.dart';
import 'package:cuan_party/room_chat_policy.dart';

void main() {
  test('open chat permits members; closed chat permits only owner/admin', () {
    for (final open in [true, false]) {
      for (final role in ['member', 'admin', 'owner']) {
        final uid = role == 'owner' ? 'jep' : role;
        final moderate = RoomChatPolicy.moderator(uid: uid, ownerUid: 'jep', role: role);
        expect(RoomChatPolicy.canSend(open: open, isMember: true, isModerator: moderate), open || role != 'member');
        expect(RoomChatPolicy.canSend(open: open, isMember: false, isModerator: moderate), false);
      }
    }
    expect(RoomChatPolicy.moderator(uid: 'outsider', ownerUid: 'jep', role: 'owner'), false);
  });
  test('own comment or moderator may delete chat; gift receipts are never deleted', () {
    for (final mod in [true, false]) {
      for (final own in [true, false]) {
        expect(RoomChatPolicy.canDelete(type: 'chat', isMember: true, isModerator: mod, uid: 'u', authorUid: own ? 'u' : 'other'), mod || own);
        expect(RoomChatPolicy.canDelete(type: 'gift', isMember: true, isModerator: mod, uid: 'u', authorUid: own ? 'u' : 'other'), false);
        expect(RoomChatPolicy.canDelete(type: 'chat', isMember: false, isModerator: mod, uid: 'u', authorUid: own ? 'u' : 'other'), false);
      }
    }
  });
}
