import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart' as app;
import 'supabase_config.dart';

/// An in-memory recovery session never signs the main application in.
class PasswordRecoveryService {
  final SupabaseClient _client;
  bool _verified = false;

  PasswordRecoveryService({SupabaseClient? client})
    : _client =
          client ??
          SupabaseClient(
            SupabaseConfig.url,
            SupabaseConfig.publishableKey,
            authOptions: const AuthClientOptions(
              autoRefreshToken: false,
              authFlowType: AuthFlowType.implicit,
            ),
          );

  Future<void> requestCode(String email) async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw const app.AuthException('Masukkan alamat email yang valid.');
    }
    _verified = false;
    await _client.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> verifyCode(String email, String code) async {
    _verified = false;
    if (!RegExp(r'^\d{6,10}$').hasMatch(code.trim())) {
      throw const app.AuthException('Masukkan kode angka dari email.');
    }
    final response = await _client.auth.verifyOTP(
      email: email.trim(),
      token: code.trim(),
      type: OtpType.recovery,
    );
    if (response.session == null) {
      throw const app.AuthException(
        'Kode belum berhasil diverifikasi. Coba lagi.',
      );
    }
    _verified = true;
  }

  Future<void> changePassword(String password) async {
    if (!_verified || _client.auth.currentSession == null) {
      throw const app.AuthException(
        'Verifikasi kode pemulihan terlebih dahulu.',
      );
    }
    if (password.length < 8) {
      throw const app.AuthException('Password baru minimal 8 karakter.');
    }
    await _client.auth.updateUser(UserAttributes(password: password));
    _verified = false;
  }

  Future<void> dispose() => _client.dispose();
}
