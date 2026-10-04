import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'services/auth_service.dart' as app;
import 'services/password_recovery_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String initialEmail;
  const ForgotPasswordPage({super.key, this.initialEmail = ''});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _service = PasswordRecoveryService();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  int _step = 0;
  bool _busy = false;
  bool _hidden = true;
  int _seconds = 0;
  Timer? _timer;
  String? _error;

  void _startCooldown() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _seconds--);
      if (_seconds <= 0) timer.cancel();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = switch (e) {
          app.AuthException() => e.message,
          sb.AuthException(code: 'otp_expired') =>
            'Kode salah atau kedaluwarsa. Periksa kode atau kirim ulang.',
          sb.AuthException(
            code: 'over_email_send_rate_limit' || 'over_request_rate_limit',
          ) =>
            'Batas pengiriman tercapai. Tunggu beberapa saat sebelum mencoba lagi.',
          sb.AuthException(code: 'same_password') =>
            'Gunakan password yang berbeda dari password lama.',
          sb.AuthException(code: 'weak_password') =>
            'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.',
          sb.AuthException() => e.message,
          _ =>
            'Tidak dapat memproses permintaan. Periksa koneksi dan coba lagi.',
        };
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send() => _run(() async {
    await _service.requestCode(_email.text);
    if (!mounted) return;
    setState(() {
      _step = 1;
      _code.clear();
      _startCooldown();
    });
  });

  Future<void> _verify() => _run(() async {
    await _service.verifyCode(_email.text, _code.text);
    if (mounted) setState(() => _step = 2);
  });

  Future<void> _save() => _run(() async {
    if (_password.text != _confirmation.text) {
      throw const app.AuthException('Konfirmasi password tidak sama.');
    }
    await _service.changePassword(_password.text);
    if (mounted) Navigator.of(context).pop(true);
  });

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirmation.dispose();
    unawaited(_service.dispose());
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFFF8F8FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = ['Lupa Password', 'Verifikasi Kode', 'Password Baru'][_step];
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F0),
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFFFFF8F0),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      color: Color(0xFFE85D75),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_step == 0) ...[
                      const Text(
                        'Masukkan email yang digunakan saat mendaftar.',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _email,
                        enabled: !_busy,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: _decoration('Email'),
                      ),
                    ],
                    if (_step == 1) ...[
                      Text(
                        'Jika email ${_email.text.trim()} terdaftar, kode pemulihan akan dikirim. Periksa kotak masuk atau spam.',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _code,
                        enabled: !_busy,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _decoration('Kode OTP'),
                      ),
                      TextButton(
                        onPressed: _busy || _seconds > 0 ? null : _send,
                        child: Text(
                          _seconds > 0
                              ? 'Kirim ulang dalam $_seconds detik'
                              : 'Kirim ulang kode',
                        ),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => setState(() {
                                _step = 0;
                                _error = null;
                              }),
                        child: const Text('Ubah email'),
                      ),
                    ],
                    if (_step == 2) ...[
                      const Text('Buat password baru minimal 8 karakter.'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _password,
                        enabled: !_busy,
                        obscureText: _hidden,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: _decoration('Password baru').copyWith(
                          suffixIcon: IconButton(
                            tooltip: _hidden
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            onPressed: () => setState(() => _hidden = !_hidden),
                            icon: Icon(
                              _hidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmation,
                        enabled: !_busy,
                        obscureText: _hidden,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: _decoration('Konfirmasi password baru'),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _busy || (_step == 0 && _seconds > 0)
                          ? null
                          : [_send, _verify, _save][_step],
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE85D75),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _busy
                            ? 'Memproses...'
                            : _step == 0 && _seconds > 0
                            ? 'Tunggu $_seconds detik'
                            : [
                                'Kirim Kode OTP',
                                'Verifikasi Kode',
                                'Simpan Password',
                              ][_step],
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
