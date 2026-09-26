import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int _startingCuanId = 1000110;

  /// Membuat profil user hanya jika belum ada.
  /// Data user yang sudah ada tidak akan ditimpa.
  static Future<void> ensureUserProfile(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      return;
    }

    final cuanId = await _allocateCuanId();

    await userRef.set({
      'cuanId': cuanId.toString(),
      'displayName': user.displayName ?? 'CUAN USER',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'coin': 0,
      'diamond': 0,
      'level': 0,
      'vip': 0,
      'svip': false,
      'frame': 'default',
      'badge': 'default',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Mengambil CUAN ID berikutnya dengan aman menggunakan transaction.
  /// ID yang mempunyai 3 angka sama berurutan dilewati.
  static Future<int> _allocateCuanId() async {
    final counterRef = _db.collection('meta').doc('cuan_id_counter');

    return _db.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int nextId = _startingCuanId;

      if (snapshot.exists) {
        final data = snapshot.data();
        final storedNextId = data?['nextCuanId'];

        if (storedNextId is int) {
          nextId = storedNextId;
        }
      }

      while (_hasTripleRepeatedDigits(nextId)) {
        nextId++;
      }

      final allocatedId = nextId;
      final nextAvailableId = allocatedId + 1;

      transaction.set(
        counterRef,
        {
          'nextCuanId': nextAvailableId,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return allocatedId;
    });
  }

  static bool _hasTripleRepeatedDigits(int number) {
    final value = number.toString();

    for (int i = 0; i <= value.length - 3; i++) {
      if (value[i] == value[i + 1] &&
          value[i] == value[i + 2]) {
        return true;
      }
    }

    return false;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
    String uid,
  ) {
    return _db.collection('users').doc(uid).get();
  }
}
