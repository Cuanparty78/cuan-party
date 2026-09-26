import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'luxury_app.dart';
import 'user_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthLoadingScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        // Only authenticated users can reach the existing Home/MainShell.
        return const MainShell();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _signInWithGoogle() async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final google = GoogleSignIn.instance;

      if (!google.supportsAuthenticate()) {
        throw Exception('Google Sign-In tidak tersedia di perangkat ini.');
      }

      final account = await google.authenticate();

      final googleAuth = account.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Google tidak mengembalikan ID token. Periksa konfigurasi Firebase/OAuth.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final currentUser = FirebaseAuth.instance.currentUser;

if (currentUser != null) {
  await UserService.ensureUserProfile(currentUser);
}
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.code == GoogleSignInExceptionCode.canceled
            ? 'Login Google dibatalkan.'
            : 'Google Sign-In gagal: ${e.description ?? e.code}';
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Firebase Auth gagal: ${e.message ?? e.code}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Login gagal: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    const ivory = Color(0xFFF7F1E3);
    const brown = Color(0xFF2A1D12);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF21160D),
                Color(0xFF120E09),
                Color(0xFF090705),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brown,
                        border: Border.all(color: gold, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x55D4AF37),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        size: 48,
                        color: gold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'CUAN PARTY',
                      style: TextStyle(
                        color: gold,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'REAL VOICES  •  REAL PEOPLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ivory,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 56),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: ivory,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masuk untuk melanjutkan ke CUAN PARTY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ivory.withValues(alpha: .65),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _signInWithGoogle,
                        icon: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.g_mobiledata_rounded, size: 30),
                        label: Text(
                          _loading
                              ? 'Menghubungkan...'
                              : 'Lanjut dengan Google',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ivory,
                          foregroundColor: Colors.black87,
                          disabledBackgroundColor: ivory.withValues(alpha: .65),
                          disabledForegroundColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0x332F1515),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x66FF6B6B),
                          ),
                        ),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFFB4B4),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 34),
                    Text(
                      'Dengan melanjutkan, kamu menyetujui ketentuan penggunaan CUAN PARTY.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ivory.withValues(alpha: .42),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF120E09),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD4AF37),
        ),
      ),
    );
  }
}
