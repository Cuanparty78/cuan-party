import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

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

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const _AuthLoadingScreen();
            }

            if (profileSnapshot.hasError) {
              return _AuthErrorScreen(
                message:
                    'Gagal memeriksa data pendaftaran.\n\n${profileSnapshot.error}',
              );
            }

            final data = profileSnapshot.data?.data();

            final registrationComplete =
                data?['registrationComplete'] == true;

            if (!registrationComplete) {
              return RegistrationScreen(
                user: user,
                existingData: data,
              );
            }

            return const MainShell();
          },
        );
      },
    );
  }
}

// ================================================================
// LOGIN SCREEN
// ================================================================

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
        throw Exception(
          'Google Sign-In tidak tersedia di perangkat ini.',
        );
      }

      final account = await google.authenticate();

      final googleAuth = account.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Google tidak mengembalikan ID token. '
          'Periksa konfigurasi Firebase/OAuth.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.code == GoogleSignInExceptionCode.canceled
            ? 'Login Google dibatalkan.'
            : 'Google Sign-In gagal: '
                '${e.description ?? e.code}';
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _error =
            'Firebase Auth gagal: ${e.message ?? e.code}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Login gagal: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
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
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brown,
                        border: Border.all(
                          color: gold,
                          width: 2,
                        ),
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
                      style: TextStyle(
                        color: ivory.withValues(alpha: .65),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed:
                            _loading ? null : _signInWithGoogle,
                        icon: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.g_mobiledata_rounded,
                                size: 30,
                              ),
                        label: Text(
                          _loading
                              ? 'Menghubungkan...'
                              : 'Lanjut dengan Google',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 18),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFB4B4),
                        ),
                      ),
                    ],
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

// ================================================================
// REGISTRATION SCREEN
// ================================================================

class RegistrationScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic>? existingData;

  const RegistrationScreen({
    super.key,
    required this.user,
    this.existingData,
  });

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {
  final _name = TextEditingController();
  final _invite = TextEditingController();

  DateTime? _birthDate;
  String? _gender;
  String _country = '';

  bool _saving = false;
  String? _error;

  static const _countries = [
    'Indonesia',
    'Malaysia',
    'Singapore',
    'Brunei',
    'Thailand',
    'Philippines',
    'Vietnam',
    'China',
    'Japan',
    'South Korea',
    'India',
    'Saudi Arabia',
    'United Arab Emirates',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final data = widget.existingData ?? {};

    _name.text =
        '${data['displayName'] ?? widget.user.displayName ?? ''}';

    _country = '${data['country'] ?? ''}';

    final genderValue = '${data['gender'] ?? ''}'.trim();

    _gender =
        genderValue.isEmpty ? null : genderValue;

    _invite.text =
        '${data['inviteCode'] ?? ''}';

    final birth = data['birthDate'];

    if (birth is Timestamp) {
      _birthDate = birth.toDate();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _invite.dispose();
    super.dispose();
  }

  // ==============================================================
  // DATE OF BIRTH
  // ==============================================================

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
          _birthDate ??
          DateTime(
            now.year - 18,
            now.month,
            now.day,
          ),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _error = null;
      });
    }
  }

  // ==============================================================
  // FINISH REGISTRATION
  // ==============================================================

  Future<void> _finishRegistration() async {
    FocusScope.of(context).unfocus();

    final name = _name.text.trim();

    // Foto Google wajib tersedia.
    final photoUrl = widget.user.photoURL?.trim() ?? '';

    if (photoUrl.isEmpty) {
      setState(() {
        _error =
            'Akun Google ini tidak memiliki foto profil. '
            'Gunakan akun Google yang memiliki foto profil.';
      });
      return;
    }

    if (name.isEmpty) {
      setState(() {
        _error = 'Nama wajib diisi.';
      });
      return;
    }

    if (_birthDate == null) {
      setState(() {
        _error = 'Tanggal lahir wajib diisi.';
      });
      return;
    }

    if (_gender == null) {
      setState(() {
        _error = 'Jenis kelamin wajib dipilih.';
      });
      return;
    }

    if (_country.isEmpty) {
      setState(() {
        _error = 'Negara wajib dipilih.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final db = FirebaseFirestore.instance;

      final ref = db
          .collection('users')
          .doc(widget.user.uid);

      final existing = await ref.get();
      final existingData = existing.data();

      // ============================================================
      // CUAN ID
      // ============================================================

      String cuanId =
          '${existingData?['cuanId'] ?? ''}'.trim();

      if (cuanId.isEmpty) {
        cuanId =
            (await UserService.allocateCuanId())
                .toString();
      }

      // ============================================================
      // REGISTRATION DATA
      // ============================================================

      await ref.set(
        {
          'cuanId': cuanId,

          'displayName': name,

          'email': widget.user.email ?? '',

          // Foto langsung dari Google.
          'photoUrl': photoUrl,

          'birthDate':
              Timestamp.fromDate(_birthDate!),

          'gender': _gender,

          'country': _country,

          // Optional.
          'inviteCode':
              _invite.text.trim(),

          'registrationComplete': true,

          // ========================================================
          // DEFAULT ACCOUNT
          // ========================================================

          'coin': 0,
          'diamond': 0,

          'level': 1,

          'vip': 0,

          'svip': 0,
          'svipPoints': 0,

          'frame': 'default',
          'badge': 'default',

          'createdAt':
              existingData?['createdAt'] ??
              FieldValue.serverTimestamp(),

          'updatedAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Update nama di Firebase Authentication.
      await widget.user.updateDisplayName(name);

      if (!mounted) return;

      // ============================================================
      // MASUK HOME
      // ============================================================

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
        (_) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Pendaftaran gagal: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF120E09);
    const ivory = Color(0xFFF7F1E3);
    const gold = Color(0xFFD4AF37);

    final googlePhoto =
        widget.user.photoURL?.trim() ?? '';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ivory,
        title: const Text(
          'Lengkapi Pendaftaran',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            children: [
              const Text(
                'Selesaikan data di bawah sebelum masuk CUAN PARTY.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xB3F7F1E3),
                ),
              ),

              const SizedBox(height: 22),

              // ======================================================
              // GOOGLE PROFILE PHOTO
              // ======================================================

              CircleAvatar(
                radius: 54,
                backgroundColor:
                    const Color(0xFF2A1D12),
                backgroundImage:
                    googlePhoto.isNotEmpty
                        ? NetworkImage(googlePhoto)
                        : null,
                child: googlePhoto.isEmpty
                    ? const Icon(
                        Icons.person_rounded,
                        color: gold,
                        size: 50,
                      )
                    : null,
              ),

              const SizedBox(height: 8),

              const Text(
                'Foto profil Google',
                style: TextStyle(
                  color: ivory,
                ),
              ),

              const SizedBox(height: 22),

              // ======================================================
              // NAME
              // ======================================================

              _field(
                _name,
                'Nama *',
                Icons.person_rounded,
              ),

              const SizedBox(height: 14),

              // ======================================================
              // BIRTH DATE
              // ======================================================

              _tapField(
                label: _birthDate == null
                    ? 'Tanggal lahir *'
                    : DateFormat(
                        'dd / MM / yyyy',
                      ).format(_birthDate!),
                icon: Icons.cake_rounded,
                onTap: _pickBirthDate,
              ),

              const SizedBox(height: 14),

              // ======================================================
              // GENDER
              // ======================================================

              DropdownButtonFormField<String>(
                value: _gender,
                dropdownColor:
                    const Color(0xFF2A1D12),
                style: const TextStyle(
                  color: ivory,
                ),
                decoration: _decoration(
                  'Jenis kelamin *',
                  Icons.wc_rounded,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        setState(() {
                          _gender = value;
                          _error = null;
                        });
                      },
              ),

              const SizedBox(height: 14),

              // ======================================================
              // COUNTRY
              // ======================================================

              DropdownButtonFormField<String>(
                value:
                    _country.isEmpty
                        ? null
                        : _country,
                dropdownColor:
                    const Color(0xFF2A1D12),
                style: const TextStyle(
                  color: ivory,
                ),
                decoration: _decoration(
                  'Negara *',
                  Icons.public_rounded,
                ),
                items: _countries
                    .map(
                      (country) =>
                          DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        setState(() {
                          _country =
                              value ?? '';
                          _error = null;
                        });
                      },
              ),

              const SizedBox(height: 14),

              // ======================================================
              // INVITATION CODE
              // ======================================================

              _field(
                _invite,
                'Kode undangan (opsional)',
                Icons.card_giftcard_rounded,
              ),

              const SizedBox(height: 26),

              // ======================================================
              // ERROR
              // ======================================================

              if (_error != null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: Text(
                    _error!,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFFFFB4B4),
                    ),
                  ),
                ),

              // ======================================================
              // REGISTER BUTTON
              // ======================================================

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      _saving
                          ? null
                          : _finishRegistration,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'DAFTAR & MASUK',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // INPUT DECORATION
  // ================================================================

  InputDecoration _decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xB3F7F1E3),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFD4AF37),
      ),
      filled: true,
      fillColor: const Color(0xFF21160D),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      enabled: !_saving,
      style: const TextStyle(
        color: Color(0xFFF7F1E3),
      ),
      decoration:
          _decoration(label, icon),
    );
  }

  Widget _tapField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _saving ? null : onTap,
      borderRadius:
          BorderRadius.circular(14),
      child: InputDecorator(
        decoration:
            _decoration(label, icon),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF7F1E3),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// LOADING SCREEN
// ================================================================

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF120E09);
    const gold = Color(0xFFD4AF37);
    const ivory = Color(0xFFF7F1E3);

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(
              color: gold,
            ),
            SizedBox(height: 18),
            Text(
              'Memuat CUAN PARTY...',
              style: TextStyle(
                color: ivory,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// ERROR SCREEN
// ================================================================

class _AuthErrorScreen extends StatelessWidget {
  final String message;

  const _AuthErrorScreen({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF120E09);
    const ivory = Color(0xFFF7F1E3);

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ivory,
            ),
          ),
        ),
      ),
    );
  }
}
