import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> openSlotKingdom(BuildContext context, {required Future<void> Function() openWallet, bool inRoom = false}) async {
  if (FirebaseAuth.instance.currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login untuk bermain SLOT KINGDOM.')));
    return;
  }
  if (inRoom) {
    await showModalBottomSheet<void>(
      context: context, isScrollControlled: true, enableDrag: false, backgroundColor: const Color(0xFF063D36),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      clipBehavior: Clip.antiAlias,
      builder: (_) => SizedBox(height: MediaQuery.sizeOf(context).height * .72,
        child: SlotKingdomPage(openWallet: openWallet, compact: true)),
    );
  } else {
    await Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => SlotKingdomPage(openWallet: openWallet)));
  }
}

class SlotKingdomPage extends StatefulWidget {
  const SlotKingdomPage({super.key, required this.openWallet, this.compact = false});
  final Future<void> Function() openWallet;
  final bool compact;
  @override
  State<SlotKingdomPage> createState() => _SlotKingdomPageState();
}

class _SlotKingdomPageState extends State<SlotKingdomPage> with WidgetsBindingObserver {
  late final WebViewController _controller;
  late final String _uid;
  StreamSubscription<User?>? _authSubscription;
  bool _walletOpen = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    WidgetsBinding.instance.addObserver(this);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF063D36))
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) {
        if (widget.compact) {
          unawaited(_controller.runJavaScript("document.body.classList.add('embedded');document.getElementById('expand').hidden=true;resizeBoard();"));
        }
      }, onNavigationRequest: (request) {
        // Bundled assets only: remote pages must never get the authenticated bridge.
        final uri = Uri.tryParse(request.url);
        return uri?.scheme == 'file' && uri!.path.contains('/flutter_assets/assets/slot_kingdom/')
            ? NavigationDecision.navigate : NavigationDecision.prevent;
      }))
      ..addJavaScriptChannel('SlotKingdomHost', onMessageReceived: (message) => unawaited(_message(message.message)))
      ..loadFlutterAsset('assets/slot_kingdom/index.html');
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user?.uid != _uid) _close();
    });
  }

  void _close() {
    if (!mounted || _closing) return;
    _closing = true;
    Navigator.of(context).pop();
  }

  Future<void> _message(String raw) async {
    if (!mounted || _closing || FirebaseAuth.instance.currentUser?.uid != _uid) return;
    Map<String, dynamic> message;
    try { message = Map<String, dynamic>.from(jsonDecode(raw) as Map); } catch (_) { return; }
    if (message['type'] == 'slotKingdom.close') { _close(); return; }
    if (message['type'] == 'slotKingdom.openWallet') {
      if (_walletOpen) return;
      _walletOpen = true;
      try { await widget.openWallet(); } finally { _walletOpen = false; }
      if (mounted && !_closing) await _controller.runJavaScript('window.slotKingdomResume?.()');
      return;
    }
    if (message['type'] != 'slotKingdom.request' || message['id'] is! String) return;
    const methods = {'state': 'slotKingdomGetState', 'spin': 'slotKingdomSpin', 'claim': 'slotKingdomClaimGoldBank'};
    final name = methods[message['method']];
    if (name == null) return;
    final id = message['id'];
    Map<String, dynamic> reply;
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'asia-southeast2').httpsCallable(name).call(message['data']);
      reply = {'id': id, 'ok': true, 'data': result.data};
    } on FirebaseFunctionsException catch (error) {
      final description = error.code == 'not-found'
          ? 'Layanan SLOT KINGDOM belum tersedia. Coba kembali nanti.'
          : error.message ?? 'Server tidak dapat dihubungi.';
      reply = {'id': id, 'ok': false, 'error': description, 'code': error.code};
    } catch (_) {
      reply = {'id': id, 'ok': false, 'error': 'Koneksi terputus. Buka kembali game untuk melanjutkan.'};
    }
    // Never deliver a result from an old account into a new session.
    if (mounted && !_closing && FirebaseAuth.instance.currentUser?.uid == _uid) {
      await _controller.runJavaScript('window.slotKingdomReply(${jsonEncode(reply)})');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(_controller.runJavaScript('auto=0;finishWin?.();RoyalAudio.pause();render();'));
    } else if (mounted && !_closing) {
      unawaited(_controller.runJavaScript('window.slotKingdomResume?.()'));
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(child: WebViewWidget(controller: _controller,
    gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
  ));
}
