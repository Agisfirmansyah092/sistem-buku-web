import '../services/book_service.dart';

import 'package:flutter/material.dart';

import 'add_book_page.dart';
import 'edit_book_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<dynamic> daftarBuku = [];
  bool loading = true;
  final _searchController = TextEditingController();
  String _query = '';

  List<dynamic> get _filteredBooks {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return daftarBuku;
    return daftarBuku
        .where(
          (book) =>
              const [
                'judul',
                'penulis',
                'penerbit',
                'kategori',
                'tahun_terbit',
              ].any(
                (field) => (book[field] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(query),
              ),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Widget _searchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Cari buku',
        hintText: 'Judul, penulis, kategori...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFFE85D75)),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: 'Hapus pencarian',
                onPressed: _clearSearch,
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ambilDataBuku();
  }

  // =========================================
  // AMBIL DATA BUKU
  // =========================================
  Future<void> ambilDataBuku() async {
    if (!mounted) return;
    setState(() {
      loading = true;
    });

    try {
      final books = await const BookService().list();
      if (!mounted) return;
      setState(() => daftarBuku = books);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal terhubung ke server: $e')));
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  // =========================================
  // TAMBAH BUKU
  // =========================================
  Future<void> bukaTambahBuku() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookPage()),
    );

    if (hasil == true) {
      await ambilDataBuku();
    }
  }

  // =========================================
  // EDIT BUKU
  // =========================================
  Future<void> bukaEditBuku(dynamic buku) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBookPage(buku: buku)),
    );

    if (hasil == true) {
      await ambilDataBuku();
    }
  }

  // =========================================
  // HAPUS BUKU
  // =========================================
  Future<void> hapusBuku(dynamic buku) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Buku'),
          content: Text('Yakin ingin menghapus "${buku['judul']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) {
      return;
    }

    try {
      await const BookService().delete(Map<String, dynamic>.from(buku));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      await ambilDataBuku();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus buku: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _header(bool mobile) {
    const heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Buku',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Kelola seluruh data buku di sini.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
    final button = ElevatedButton.icon(
      onPressed: bukaTambahBuku,
      icon: const Icon(Icons.add),
      label: const Text('Tambah Buku'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE85D75),
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [heading, const SizedBox(height: 16), button],
      );
    }
    return Row(
      children: [
        const Expanded(child: heading),
        const SizedBox(width: 24),
        button,
      ],
    );
  }

  Widget _totalBooks() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.library_books_outlined,
            color: Color(0xFFE85D75),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Total Buku: ${daftarBuku.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _filteredBooks;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Data Buku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2A33),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: ambilDataBuku,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final mobile = constraints.maxWidth < 700 * scale;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(mobile ? 16 : 30),
                  sliver: SliverList.list(
                    children: [
                      _header(mobile),
                      const SizedBox(height: 25),
                      _totalBooks(),
                      const SizedBox(height: 16),
                      _searchBar(),
                      if (!loading && _query.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          '${filteredBooks.length} buku ditemukan',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
                if (loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (daftarBuku.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 70,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Belum ada data buku',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (filteredBooks.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tidak ada buku yang cocok.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _clearSearch,
                              child: const Text('Tampilkan semua buku'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      mobile ? 16 : 30,
                      0,
                      mobile ? 16 : 30,
                      mobile ? 16 : 30,
                    ),
                    sliver: SliverList.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final buku = filteredBooks[index];
                        return BookCard(
                          buku: buku,
                          onEdit:
                              const BookService().canEdit(
                                Map<String, dynamic>.from(buku),
                              )
                              ? () {
                                  bukaEditBuku(buku);
                                }
                              : null,
                          onDelete:
                              const BookService().canEdit(
                                Map<String, dynamic>.from(buku),
                              )
                              ? () {
                                  hapusBuku(buku);
                                }
                              : null,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final dynamic buku;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BookCard({
    super.key,
    required this.buku,
    required this.onEdit,
    required this.onDelete,
  });

  Widget _cover(bool mobile) {
    final coverUrl = BookService.coverUrl((buku['foto'] ?? '').toString());
    return Container(
      width: mobile ? 120 : 100,
      height: mobile ? 162 : 135,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: coverUrl.isEmpty
          ? const Icon(
              Icons.menu_book_rounded,
              size: 45,
              color: Color(0xFFE85D75),
            )
          : Image.network(
              coverUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image_outlined,
                size: 45,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _detail(String label, Object? value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: '${value ?? '-'}',
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 14, height: 1.45),
      ),
    );
  }

  Widget _information() {
    final title = (buku['judul'] ?? '-').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Tooltip(
          message: title,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        _detail('Penulis', buku['penulis']),
        _detail('Penerbit', buku['penerbit']),
        _detail('Tahun Terbit', buku['tahun_terbit']),
        _detail('Kategori', buku['kategori']),
        _detail('Stok', buku['stok'] ?? '0', bold: true),
      ],
    );
  }

  Widget _actions() {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 12,
        runSpacing: 8,
        children: [
          IconButton(
            tooltip: 'Edit Buku',
            onPressed: onEdit,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
          ),
          IconButton(
            tooltip: 'Hapus Buku',
            onPressed: onDelete,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final mobile = constraints.maxWidth < 600 * scale;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: EdgeInsets.all(mobile ? 16 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (mobile) ...[
                  Align(alignment: Alignment.centerLeft, child: _cover(true)),
                  const SizedBox(height: 16),
                  _information(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cover(false),
                      const SizedBox(width: 20),
                      Expanded(child: _information()),
                    ],
                  ),
                const SizedBox(height: 12),
                _actions(),
              ],
            ),
          ),
        );
      },
    );
  }
}
