import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class EconomyService {
  EconomyService({FirebaseFirestore? firestore, FirebaseFunctions? functions})
      : _db = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'asia-southeast2');

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  DocumentReference<Map<String, dynamic>> economyRef(String uid) =>
      _db.collection('users').doc(uid).collection('private').doc('economy');

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchEconomy(String uid) =>
      economyRef(uid).snapshots();

  Future<void> ensureBackendEconomy() async {
    // Backend initialization must be performed by trusted server code.
    // This method intentionally performs no direct Firestore write.
    return;
  }

  Future<Map<String, dynamic>?> getEconomyOnce(String uid) async {
    final snap = await economyRef(uid).get();
    return snap.exists ? snap.data() : null;
  }

  Stream<Map<String, dynamic>?> watchEconomyData(String uid) {
    return watchEconomy(uid).map((snap) => snap.data());
  }

  Future<Map<String, dynamic>> getSvipStatus() async {
    final result = await _functions.httpsCallable('getSvipStatus').call();
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> purchaseVip({
    required int vipLevel,
    required String transactionId,
  }) async {
    final result = await _functions.httpsCallable('purchaseVip').call({
      'vipLevel': vipLevel,
      'transactionId': transactionId,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> claimVipCheckin({
    required String dateKey,
    required String transactionId,
  }) async {
    final result = await _functions.httpsCallable('claimVipCheckin').call({
      'dateKey': dateKey,
      'transactionId': transactionId,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> exchangeDiamondToCoin({
    required int diamond,
    required String transactionId,
  }) async {
    final result = await _functions.httpsCallable('exchangeDiamondToCoin').call({
      'diamond': diamond,
      'transactionId': transactionId,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> sendGift({
    required String receiverUid,
    required String giftId,
    required int quantity,
    required String transactionId,
  }) async {
    final result = await _functions.httpsCallable('sendGift').call({
      'receiverUid': receiverUid,
      'giftId': giftId,
      'quantity': quantity,
      'transactionId': transactionId,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }
}
