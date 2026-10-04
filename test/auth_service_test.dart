import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:sistem_buku/services/auth_service.dart';

class MemoryAuthStorage extends sb.GotrueAsyncStorage {
  final values = <String, String>{};
  @override
  Future<String?> getItem({required String key}) async => values[key];
  @override
  Future<void> setItem({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> removeItem({required String key}) async {
    values.remove(key);
  }
}

void main() {
  sb.SupabaseClient makeClient(
    Future<http.Response> Function(http.Request) handler,
  ) {
    final client = sb.SupabaseClient(
      'https://example.supabase.co',
      'public-test-key',
      httpClient: MockClient(handler),
      authOptions: sb.AuthClientOptions(
        autoRefreshToken: false,
        pkceAsyncStorage: MemoryAuthStorage(),
      ),
    );
    addTearDown(client.dispose);
    return client;
  }

  test('Login mengirim email dan password tanpa mengubah password', () async {
    final client = makeClient((request) async {
      expect(request.url.path, '/auth/v1/token');
      expect(request.url.queryParameters['grant_type'], 'password');
      final data = jsonDecode(request.body);
      expect(data['email'], 'anggota@example.com');
      expect(data['password'], ' secret ');
      return http.Response(
        jsonEncode({
          'access_token': 'test-token',
          'refresh_token': 'test-refresh',
          'token_type': 'bearer',
          'expires_in': 3600,
          'user': {
            'id': 'user-a',
            'aud': 'authenticated',
            'email': 'anggota@example.com',
            'created_at': '2026-01-01T00:00:00Z',
            'app_metadata': {},
            'user_metadata': {},
          },
        }),
        200,
      );
    });
    await AuthService(
      client: client,
    ).login(' anggota@example.com ', ' secret ');
    expect(client.auth.currentSession, isNotNull);
  });

  test('Password salah tidak menghasilkan sesi', () async {
    final client = makeClient(
      (_) async => http.Response(
        '{"code":"invalid_credentials","msg":"Invalid login credentials"}',
        400,
        headers: {'x-supabase-api-version': '2024-01-01'},
      ),
    );
    await expectLater(
      AuthService(client: client).login('a@example.com', 'salah'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Email atau password salah.',
        ),
      ),
    );
    expect(client.auth.currentSession, isNull);
  });

  test('Daftar tanpa sesi meminta konfirmasi email', () async {
    final client = makeClient((request) async {
      expect(request.url.path, '/auth/v1/signup');
      expect(jsonDecode(request.body)['data'], {
        'nama': 'Nama',
        'username': 'anggota',
      });
      return http.Response(
        jsonEncode({
          'id': 'user-a',
          'aud': 'authenticated',
          'email': 'a@example.com',
          'created_at': '2026-01-01T00:00:00Z',
          'app_metadata': {},
          'user_metadata': {},
        }),
        200,
      );
    });
    final result = await AuthService(client: client).register(
      nama: ' Nama ',
      username: ' anggota ',
      email: 'a@example.com',
      password: 'password123',
    );
    expect(result.needsConfirmation, isTrue);
    expect(client.auth.currentSession, isNull);
  });
}
