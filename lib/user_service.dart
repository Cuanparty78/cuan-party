import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int _startingCuanId = 1000110;

  /// Finishes registration atomically without changing an existing CUAN ID or
  /// resetting balances. This also prevents two simultaneous registrations
  /// from claiming different room IDs for the same Firebase UID.
  static Future<String> completeRegistration({
    required User user,
    required String displayName,
    required String photoUrl,
    required DateTime birthDate,
    required String gender,
    required String country,
    required String inviteCode,
  }) async {
    final userRef = _db.collection('users').doc(user.uid);
    final counterRef = _db.collection('meta').doc('cuan_id_counter');

    return _db.runTransaction<String>((tx) async {
      final snapshot = await tx.get(userRef);
      final old = snapshot.data() ?? <String, dynamic>{};
      var cuanId = '${old['cuanId'] ?? ''}'.trim();

      if (old['registrationComplete'] == true) {
        if (!RegExp(r'^[0-9]+
  /// Creates a new profile or repairs only missing core fields on an existing profile.
  /// Existing user data is preserved.
  static Future<void> ensureUserProfile(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final cuanId = await _allocateCuanId();
      await userRef.set({
        'cuanId': cuanId.toString(),
        'displayName': (user.displayName ?? '').trim(),
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'coin': 0,
        'diamond': 0,
        'level': 1,
        'wealthLevel': 1,
        'charmLevel': 1,
        'gameLevel': 1,
        'vip': 0,
        'svip': 0,
        'svipPoints': 0,
        'frame': 'default',
        'badge': 'default',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    // Existing accounts from older builds may be missing these fields.
    // Repair them without overwriting user-entered profile data.
    final data = snapshot.data() ?? <String, dynamic>{};
    final patch = <String, dynamic>{};

    if (data['cuanId'] == null || '${data['cuanId']}'.trim().isEmpty) {
      patch['cuanId'] = (await _allocateCuanId()).toString();
    }
    if (data['displayName'] == null ||
        '${data['displayName']}'.trim().isEmpty) {
      patch['displayName'] = (user.displayName ?? '').trim();
    }
    if (data['coin'] == null) patch['coin'] = 0;
    if (data['diamond'] == null) patch['diamond'] = 0;
    if (data['level'] == null ||
        (data['level'] is num && (data['level'] as num).toInt() < 1)) {
      patch['level'] = 1;
    }
    if (data['wealthLevel'] == null) patch['wealthLevel'] = 1;
    if (data['charmLevel'] == null) patch['charmLevel'] = 1;
    if (data['gameLevel'] == null) patch['gameLevel'] = 1;
    if (data['vip'] == null) patch['vip'] = 0;
    if (data['svip'] == null) patch['svip'] = 0;
    if (data['svipPoints'] == null) patch['svipPoints'] = 0;

    if (patch.isNotEmpty) {
      patch['updatedAt'] = FieldValue.serverTimestamp();
      await userRef.set(patch, SetOptions(merge: true));
    }
  }
static Future<int> allocateCuanId() {
  return _allocateCuanId();
}
  static Future<int> _allocateCuanId() async {
    final counterRef = _db.collection('meta').doc('cuan_id_counter');

    return _db.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int nextId = _startingCuanId;

      if (snapshot.exists) {
        final data = snapshot.data();
        final storedNextId = data?['nextCuanId'];
        if (storedNextId is int) nextId = storedNextId;
      }

      while (_hasTripleRepeatedDigits(nextId)) {
        nextId++;
      }

      final allocatedId = nextId;
      transaction.set(
        counterRef,
        {
          'nextCuanId': allocatedId + 1,
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
      if (value[i] == value[i + 1] && value[i] == value[i + 2]) return true;
    }
    return false;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }
}
).hasMatch(cuanId)) {
          throw StateError('ACCOUNT_ID_INVALID');
        }
        return cuanId;
      }

      if (cuanId.isEmpty) {
        final counter = await tx.get(counterRef);
        final stored = counter.data()?['nextCuanId'];
        var next = stored is int && stored >= _startingCuanId
            ? stored
            : _startingCuanId;
        while (_hasTripleRepeatedDigits(next)) {
          next++;
        }
        cuanId = next.toString();
        tx.set(counterRef, {
          'nextCuanId': next + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else if (!RegExp(r'^[0-9]+
  /// Creates a new profile or repairs only missing core fields on an existing profile.
  /// Existing user data is preserved.
  static Future<void> ensureUserProfile(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final cuanId = await _allocateCuanId();
      await userRef.set({
        'cuanId': cuanId.toString(),
        'displayName': (user.displayName ?? '').trim(),
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'coin': 0,
        'diamond': 0,
        'level': 1,
        'wealthLevel': 1,
        'charmLevel': 1,
        'gameLevel': 1,
        'vip': 0,
        'svip': 0,
        'svipPoints': 0,
        'frame': 'default',
        'badge': 'default',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    // Existing accounts from older builds may be missing these fields.
    // Repair them without overwriting user-entered profile data.
    final data = snapshot.data() ?? <String, dynamic>{};
    final patch = <String, dynamic>{};

    if (data['cuanId'] == null || '${data['cuanId']}'.trim().isEmpty) {
      patch['cuanId'] = (await _allocateCuanId()).toString();
    }
    if (data['displayName'] == null ||
        '${data['displayName']}'.trim().isEmpty) {
      patch['displayName'] = (user.displayName ?? '').trim();
    }
    if (data['coin'] == null) patch['coin'] = 0;
    if (data['diamond'] == null) patch['diamond'] = 0;
    if (data['level'] == null ||
        (data['level'] is num && (data['level'] as num).toInt() < 1)) {
      patch['level'] = 1;
    }
    if (data['wealthLevel'] == null) patch['wealthLevel'] = 1;
    if (data['charmLevel'] == null) patch['charmLevel'] = 1;
    if (data['gameLevel'] == null) patch['gameLevel'] = 1;
    if (data['vip'] == null) patch['vip'] = 0;
    if (data['svip'] == null) patch['svip'] = 0;
    if (data['svipPoints'] == null) patch['svipPoints'] = 0;

    if (patch.isNotEmpty) {
      patch['updatedAt'] = FieldValue.serverTimestamp();
      await userRef.set(patch, SetOptions(merge: true));
    }
  }
static Future<int> allocateCuanId() {
  return _allocateCuanId();
}
  static Future<int> _allocateCuanId() async {
    final counterRef = _db.collection('meta').doc('cuan_id_counter');

    return _db.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int nextId = _startingCuanId;

      if (snapshot.exists) {
        final data = snapshot.data();
        final storedNextId = data?['nextCuanId'];
        if (storedNextId is int) nextId = storedNextId;
      }

      while (_hasTripleRepeatedDigits(nextId)) {
        nextId++;
      }

      final allocatedId = nextId;
      transaction.set(
        counterRef,
        {
          'nextCuanId': allocatedId + 1,
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
      if (value[i] == value[i + 1] && value[i] == value[i + 2]) return true;
    }
    return false;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }
}
).hasMatch(cuanId)) {
        throw StateError('ACCOUNT_ID_INVALID');
      }

      // Only initialize missing defaults. Existing real balances, VIP levels,
      // creation date, and account ID are never overwritten by registration.
      final patch = <String, dynamic>{
        'cuanId': cuanId,
        'displayName': displayName.trim(),
        'email': user.email ?? '',
        'photoUrl': photoUrl,
        'birthDate': Timestamp.fromDate(birthDate),
        'gender': gender,
        'country': country,
        'inviteCode': inviteCode.trim(),
        'registrationComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
        if (old['createdAt'] == null)
          'createdAt': FieldValue.serverTimestamp(),
        if (old['coin'] == null) 'coin': 0,
        if (old['diamond'] == null) 'diamond': 0,
        if (old['level'] == null) 'level': 1,
        if (old['wealthLevel'] == null) 'wealthLevel': 1,
        if (old['charmLevel'] == null) 'charmLevel': 1,
        if (old['gameLevel'] == null) 'gameLevel': 1,
        if (old['vip'] == null) 'vip': 0,
        if (old['svip'] == null) 'svip': 0,
        if (old['svipPoints'] == null) 'svipPoints': 0,
        if (old['frame'] == null) 'frame': 'default',
        if (old['badge'] == null) 'badge': 'default',
      };
      tx.set(userRef, patch, SetOptions(merge: true));
      return cuanId;
    });
  }


  /// Creates a new profile or repairs only missing core fields on an existing profile.
  /// Existing user data is preserved.
  static Future<void> ensureUserProfile(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final cuanId = await _allocateCuanId();
      await userRef.set({
        'cuanId': cuanId.toString(),
        'displayName': (user.displayName ?? '').trim(),
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'coin': 0,
        'diamond': 0,
        'level': 1,
        'wealthLevel': 1,
        'charmLevel': 1,
        'gameLevel': 1,
        'vip': 0,
        'svip': 0,
        'svipPoints': 0,
        'frame': 'default',
        'badge': 'default',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    // Existing accounts from older builds may be missing these fields.
    // Repair them without overwriting user-entered profile data.
    final data = snapshot.data() ?? <String, dynamic>{};
    final patch = <String, dynamic>{};

    if (data['cuanId'] == null || '${data['cuanId']}'.trim().isEmpty) {
      patch['cuanId'] = (await _allocateCuanId()).toString();
    }
    if (data['displayName'] == null ||
        '${data['displayName']}'.trim().isEmpty) {
      patch['displayName'] = (user.displayName ?? '').trim();
    }
    if (data['coin'] == null) patch['coin'] = 0;
    if (data['diamond'] == null) patch['diamond'] = 0;
    if (data['level'] == null ||
        (data['level'] is num && (data['level'] as num).toInt() < 1)) {
      patch['level'] = 1;
    }
    if (data['wealthLevel'] == null) patch['wealthLevel'] = 1;
    if (data['charmLevel'] == null) patch['charmLevel'] = 1;
    if (data['gameLevel'] == null) patch['gameLevel'] = 1;
    if (data['vip'] == null) patch['vip'] = 0;
    if (data['svip'] == null) patch['svip'] = 0;
    if (data['svipPoints'] == null) patch['svipPoints'] = 0;

    if (patch.isNotEmpty) {
      patch['updatedAt'] = FieldValue.serverTimestamp();
      await userRef.set(patch, SetOptions(merge: true));
    }
  }
static Future<int> allocateCuanId() {
  return _allocateCuanId();
}
  static Future<int> _allocateCuanId() async {
    final counterRef = _db.collection('meta').doc('cuan_id_counter');

    return _db.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int nextId = _startingCuanId;

      if (snapshot.exists) {
        final data = snapshot.data();
        final storedNextId = data?['nextCuanId'];
        if (storedNextId is int) nextId = storedNextId;
      }

      while (_hasTripleRepeatedDigits(nextId)) {
        nextId++;
      }

      final allocatedId = nextId;
      transaction.set(
        counterRef,
        {
          'nextCuanId': allocatedId + 1,
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
      if (value[i] == value[i + 1] && value[i] == value[i + 2]) return true;
    }
    return false;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }
}
