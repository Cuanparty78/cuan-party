import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
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
    if (uid.isEmpty) return Stream.value(null);
    late StreamController<Map<String, dynamic>?> controller;
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? rootSub, economySub;
    Map<String, dynamic>? root, economy;
    var rootLoaded = false, economyLoaded = false;
    void publish() {
      if (rootLoaded && economyLoaded && !controller.isClosed) {
        controller.add(root == null && economy == null ? null : {...?root, ...?economy});
      }
    }
    controller = StreamController(onListen: () {
      rootSub = _db.collection('users').doc(uid).snapshots().listen((snap) {
        root = snap.data(); rootLoaded = true; publish();
      }, onError: controller.addError);
      economySub = watchEconomy(uid).listen((snap) {
        economy = snap.data(); economyLoaded = true; publish();
      }, onError: controller.addError);
    }, onCancel: () async { await rootSub?.cancel(); await economySub?.cancel(); });
    return controller.stream;
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

  static const String _freeGiftWorkerUrl =
      String.fromEnvironment('CUAN_GIFT_WORKER_URL');

  /// When a free-tier worker URL is configured, use the trusted Worker to
  /// settle the gift transaction. No client-side coin minting is allowed.
  Future<Map<String, dynamic>> _sendGiftUsingWorker({
    required String roomId,
    required String targetName,
    required String giftName,
    required int quantity,
    required String transactionId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Login dahulu untuk mengirim gift.');
    }
    final endpoint = Uri.parse(
      '${_freeGiftWorkerUrl.replaceAll(RegExp(r"/+$"), "")}/gift/send',
    );
    if (endpoint.scheme != 'https') {
      throw StateError('Server gift harus menggunakan HTTPS.');
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw StateError('Sesi login sudah habis, silakan login ulang.');
    }
    final response = await http
        .post(
          endpoint,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'roomId': roomId,
            'targetName': targetName,
            'giftName': giftName,
            'quantity': quantity,
            'transactionId': transactionId,
          }),
        )
        .timeout(const Duration(seconds: 20));
    final dynamic payload;
    try {
      payload = jsonDecode(response.body);
    } on FormatException {
      throw StateError('Respons server gift tidak valid.');
    }
    if (payload is! Map) {
      throw StateError('Respons server gift tidak valid.');
    }
    final data = Map<String, dynamic>.from(payload);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(data['error']?.toString() ?? 'Gift gagal dikirim.');
    }
    return data;
  }

  Future<Map<String, dynamic>> sendRoomGift({required String roomId, required String targetName,
    required String giftName, required int quantity, required String transactionId}) async {
    if (_freeGiftWorkerUrl.trim().isNotEmpty) {
      return _sendGiftUsingWorker(
        roomId: roomId, targetName: targetName, giftName: giftName,
        quantity: quantity, transactionId: transactionId,
      );
    }
    final result = await _functions.httpsCallable('sendRoomGift').call({
      'roomId': roomId, 'targetName': targetName, 'giftName': giftName,
      'quantity': quantity, 'transactionId': transactionId,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }
}
