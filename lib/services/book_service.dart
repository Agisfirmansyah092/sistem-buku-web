import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

class BookException implements Exception {
  final String message;
  const BookException(this.message);
  @override
  String toString() => message;
}

class BookService {
  final SupabaseClient? client;
  const BookService({this.client});
  SupabaseClient get _client => client ?? Supabase.instance.client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const BookException('Sesi berakhir. Silakan login lagi.');
    }
    return id;
  }

  bool canEdit(Map<String, dynamic> book) =>
      _client.auth.currentUser != null && book['owner_id'] == _userId;

  Future<List<Map<String, dynamic>>> list({int? limit}) async {
    _userId;
    final query = _client
        .from('books')
        .select()
        .order('created_at', ascending: false);
    return await (limit == null ? query : query.limit(limit));
  }

  static Map<String, dynamic> validate(Map<String, String> fields) {
    final result = <String, dynamic>{};
    for (final entry in {
      'judul': 200,
      'penulis': 200,
      'penerbit': 200,
      'kategori': 100,
    }.entries) {
      final value = (fields[entry.key] ?? '').trim();
      if ((entry.key != 'penerbit' && value.isEmpty) ||
          value.length > entry.value) {
        throw BookException(
          '${entry.key} wajib diisi, maksimal ${entry.value} karakter (penerbit opsional).',
        );
      }
      result[entry.key] = value;
    }
    final tahun = int.tryParse((fields['tahun_terbit'] ?? '').trim());
    final stok = int.tryParse((fields['stok'] ?? '').trim());
    if (tahun == null || tahun < 1 || tahun > 9999) {
      throw const BookException('Tahun terbit harus angka antara 1 dan 9999.');
    }
    if (stok == null || stok < 0 || stok > 2147483647) {
      throw const BookException(
        'Stok harus bilangan bulat 0 sampai 2147483647.',
      );
    }
    return {...result, 'tahun_terbit': tahun, 'stok': stok};
  }

  Future<void> save(
    Map<String, String> fields, {
    Map<String, dynamic>? existing,
    Uint8List? cover,
  }) async {
    final userId = _userId;
    final values = validate(fields);
    if (existing != null && !canEdit(existing)) {
      throw const BookException('Hanya pembuat buku yang boleh mengubahnya.');
    }
    String? uploaded;
    if (cover != null) uploaded = await _upload(cover, userId);
    try {
      if (uploaded != null) values['foto'] = uploaded;
      if (existing == null) {
        await _client.from('books').insert({...values, 'owner_id': userId});
      } else {
        final rows = await _client
            .from('books')
            .update(values)
            .eq('id', existing['id'])
            .eq('owner_id', userId)
            .select('id');
        if (rows.isEmpty) {
          throw const BookException(
            'Buku sudah dihapus atau tidak dapat diubah.',
          );
        }
      }
    } on PostgrestException {
      // A database rejection is definitive; remove its unused upload.
      // Leave uploads intact on network errors because the write may have committed.
      if (uploaded != null) await _removeCover(uploaded);
      rethrow;
    }
    if (uploaded != null && existing?['foto'] != null) {
      await _removeCover(existing!['foto'].toString());
    }
  }

  Future<void> delete(Map<String, dynamic> book) async {
    if (!canEdit(book)) {
      throw const BookException('Hanya pembuat buku yang boleh menghapusnya.');
    }
    final rows = await _client
        .from('books')
        .delete()
        .eq('id', book['id'])
        .eq('owner_id', _userId)
        .select('id');
    if (rows.isEmpty) {
      throw const BookException('Buku sudah dihapus atau tidak dapat dihapus.');
    }
    if (book['foto'] != null) {
      await _removeCover(book['foto'].toString());
    }
  }

  static String imageType(Uint8List bytes) {
    if (bytes.length > 5 * 1024 * 1024) {
      throw const BookException('Cover maksimal 5 MB.');
    }
    if (bytes.length >= 3 &&
        bytes[0] == 255 &&
        bytes[1] == 216 &&
        bytes[2] == 255) {
      return 'jpeg';
    }
    if (bytes.length >= 8 &&
        listEquals(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10])) {
      return 'png';
    }
    if (bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
      return 'webp';
    }
    throw const BookException('Pilih cover JPG, PNG, atau WebP yang valid.');
  }

  Future<String> _upload(Uint8List bytes, String userId) async {
    final type = imageType(bytes);
    final random = Random.secure();
    final suffix = List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final path = '$userId/$suffix.$type';
    await _client.storage
        .from(SupabaseConfig.coversBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$type'),
        );
    return path;
  }

  Future<void> _removeCover(String path) async {
    final id = _client.auth.currentUser?.id;
    if (id == null || !path.startsWith('$id/')) return;
    try {
      await _client.storage.from(SupabaseConfig.coversBucket).remove([path]);
    } catch (_) {
      // The book mutation succeeded. A stale object can be cleaned in Storage.
      debugPrint('Cover lama belum terhapus dari Storage.');
    }
  }

  static String coverUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '${SupabaseConfig.url}/storage/v1/object/public/'
        '${SupabaseConfig.coversBucket}/${path.split('/').map(Uri.encodeComponent).join('/')}';
  }
}
