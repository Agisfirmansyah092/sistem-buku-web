import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class RegistrationResult {
  final String email;
  final bool needsConfirmation;
  const RegistrationResult(this.email, this.needsConfirmation);
}

class AuthService {
  final sb.SupabaseClient? client;
  const AuthService({this.client});
  sb.SupabaseClient get _client => client ?? sb.Supabase.instance.client;

  Future<void> login(String email, String password) async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw const AuthException(
        'Masukkan email yang digunakan saat mendaftar.',
      );
    }
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      if (response.session == null) {
        throw const AuthException('Login belum berhasil. Silakan coba lagi.');
      }
    } on sb.AuthException catch (e) {
      throw AuthException(_message(e));
    } on http.ClientException {
      throw const AuthException(
        'Tidak dapat terhubung ke Supabase. Periksa internet.',
      );
    } on TimeoutException {
      throw const AuthException('Koneksi terlalu lama. Coba lagi.');
    }
  }

  Future<RegistrationResult> register({
    required String nama,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'nama': nama.trim(), 'username': username.trim()},
      );
      if (response.user == null) {
        throw const AuthException('Pendaftaran belum berhasil. Coba lagi.');
      }
      return RegistrationResult(email.trim(), response.session == null);
    } on sb.AuthException catch (e) {
      throw AuthException(_message(e));
    } on http.ClientException {
      throw const AuthException(
        'Tidak dapat terhubung ke Supabase. Periksa internet.',
      );
    } on TimeoutException {
      throw const AuthException('Koneksi terlalu lama. Coba lagi.');
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut(scope: sb.SignOutScope.local);
    } on sb.AuthException catch (e) {
      throw AuthException(_message(e));
    } on http.ClientException {
      throw const AuthException(
        'Logout gagal. Periksa internet dan coba lagi.',
      );
    }
  }

  static String _message(sb.AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return 'Email atau password salah.';
      case 'email_not_confirmed':
        return 'Konfirmasi email terlebih dahulu melalui kotak masuk atau spam.';
      case 'user_already_exists':
      case 'email_exists':
        return 'Email sudah terdaftar. Silakan login.';
      case 'weak_password':
        return 'Password terlalu lemah. Gunakan password yang lebih kuat.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Terlalu banyak percobaan. Tunggu beberapa saat lalu coba lagi.';
      case 'signup_disabled':
        return 'Pendaftaran belum diaktifkan pada Supabase.';
      default:
        return e.message;
    }
  }
}
