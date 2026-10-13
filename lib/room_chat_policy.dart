class RoomChatPolicy {
  static bool moderator({required String uid, required String ownerUid, String? role}) => uid.isNotEmpty && (uid == ownerUid || role == 'admin');
  static bool canSend({required bool open, required bool isMember, required bool isModerator}) => isMember && (open || isModerator);
  static bool canDelete({required String type, required bool isMember, required bool isModerator, required String uid, required String authorUid}) =>
    type == 'chat' && isMember && uid.isNotEmpty && (isModerator || uid == authorUid);
}
