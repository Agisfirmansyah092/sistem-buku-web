import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sistem_buku/services/book_service.dart';

void main() {
  const fields = {
    'judul': ' Buku ',
    'penulis': 'Penulis',
    'penerbit': '',
    'kategori': 'Novel',
    'tahun_terbit': '2026',
    'stok': '0',
  };

  test('Data buku ditrim, angka dikonversi, penerbit opsional', () {
    final values = BookService.validate(fields);
    expect(values['judul'], 'Buku');
    expect(values['stok'], 0);
    expect(values['tahun_terbit'], 2026);
    expect(values['penerbit'], '');
  });

  for (final invalid in [
    {'stok': '-1'},
    {'stok': '1.5'},
    {'tahun_terbit': 'abc'},
    {'tahun_terbit': '0'},
    {'judul': '  '},
  ]) {
    test('Data tidak valid ditolak: $invalid', () {
      expect(
        () => BookService.validate({...fields, ...invalid}),
        throwsA(isA<BookException>()),
      );
    });
  }

  test('File HTML dan cover terlalu besar ditolak', () {
    expect(
      () => BookService.imageType(Uint8List.fromList('<html>'.codeUnits)),
      throwsA(isA<BookException>()),
    );
    expect(
      () => BookService.imageType(Uint8List(5 * 1024 * 1024 + 1)),
      throwsA(isA<BookException>()),
    );
  });

  test('Tanpa login, data tidak diminta dari server', () async {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'public-key',
      httpClient: MockClient(
        (_) async => fail('Request tanpa sesi tidak boleh dikirim'),
      ),
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    addTearDown(client.dispose);
    final service = BookService(client: client);
    await expectLater(service.list(), throwsA(isA<BookException>()));
    await expectLater(service.save(fields), throwsA(isA<BookException>()));
    expect(service.canEdit({'owner_id': 'someone-else'}), isFalse);
  });
}
