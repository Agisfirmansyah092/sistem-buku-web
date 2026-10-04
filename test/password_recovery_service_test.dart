import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:sistem_buku/services/auth_service.dart';
import 'package:sistem_buku/services/password_recovery_service.dart';

void main() {
  final user = {
    'id': 'user-a',
    'aud': 'authenticated',
    'email': 'a@example.com',
    'created_at': '2026-01-01T00:00:00Z',
    'app_metadata': <String, dynamic>{},
    'user_metadata': <String, dynamic>{},
  };

  PasswordRecoveryService serviceWith(
    Future<http.Response> Function(http.Request) handler,
  ) {
    final service = PasswordRecoveryService(
      client: sb.SupabaseClient(
        'https://example.supabase.co',
        'public-test-key',
        httpClient: MockClient(handler),
        authOptions: const sb.AuthClientOptions(
          autoRefreshToken: false,
          authFlowType: sb.AuthFlowType.implicit,
        ),
      ),
    );
    addTearDown(service.dispose);
    return service;
  }

  test('Cannot update password without recovery verification', () async {
    final service = serviceWith((_) async {
      fail('Unverified password update must not make a request');
    });
    await expectLater(
      service.changePassword('New-password1'),
      throwsA(isA<AuthException>()),
    );
  });

  test('Rejected OTP cannot authorize a password update', () async {
    var requests = 0;
    final service = serviceWith((request) async {
      requests++;
      expect(request.url.path, '/auth/v1/verify');
      return http.Response(
        '{"code":"otp_expired","msg":"Expired"}',
        403,
        headers: {'x-supabase-api-version': '2024-01-01'},
      );
    });
    await expectLater(
      service.verifyCode('a@example.com', '123456'),
      throwsA(isA<sb.AuthException>()),
    );
    await expectLater(
      service.changePassword('New-password1'),
      throwsA(isA<AuthException>()),
    );
    expect(requests, 1);
  });

  test(
    'Requests recovery, verifies recovery OTP, updates authenticated user',
    () async {
      final paths = <String>[];
      final service = serviceWith((request) async {
        paths.add(request.url.path);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        switch (request.url.path) {
          case '/auth/v1/recover':
            expect(body['email'], 'a@example.com');
            return http.Response('{}', 200);
          case '/auth/v1/verify':
            expect(body['type'], 'recovery');
            expect(body['token'], '123456');
            expect(body['email'], 'a@example.com');
            return http.Response(
              jsonEncode({
                'access_token': 'recovery-token',
                'refresh_token': 'recovery-refresh',
                'token_type': 'bearer',
                'expires_in': 3600,
                'user': user,
              }),
              200,
            );
          case '/auth/v1/user':
            expect(request.method, 'PUT');
            expect(request.headers['Authorization'], 'Bearer recovery-token');
            expect(body['password'], ' New-password1 ');
            return http.Response(jsonEncode(user), 200);
          default:
            fail('Unexpected request: ${request.url}');
        }
      });
      await service.requestCode(' a@example.com ');
      await service.verifyCode('a@example.com', '123456');
      await service.changePassword(' New-password1 ');
      expect(paths, ['/auth/v1/recover', '/auth/v1/verify', '/auth/v1/user']);
      await expectLater(
        service.changePassword('Another-password1'),
        throwsA(isA<AuthException>()),
      );
    },
  );
}
