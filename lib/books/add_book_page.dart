import '../services/book_service.dart';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final judulController = TextEditingController();
  final penulisController = TextEditingController();
  final penerbitController = TextEditingController();
  final tahunController = TextEditingController();
  final stokController = TextEditingController();
  final kategoriController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? fotoBuku;
  Uint8List? fotoBytes;

  bool sedangMenyimpan = false;
  bool sedangMemuatCover = false;

  Future<void> pilihFoto() async {
    try {
      final XFile? foto = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (foto != null) {
        final bytes = await foto.readAsBytes();
        if (!mounted) return;

        if (bytes.isEmpty) {
          throw Exception('File foto kosong');
        }

        setState(() {
          fotoBuku = foto;
          fotoBytes = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'File bukan foto yang valid. Pilih JPG, JPEG, atau PNG.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> gunakanCoverLaskarPelangi() async {
    setState(() {
      sedangMemuatCover = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://covers.openlibrary.org/b/isbn/9789793062792-L.jpg'),
      );

      if (response.statusCode != 200) {
        throw Exception('Cover tidak ditemukan');
      }

      final bytes = response.bodyBytes;

      if (!mounted) return;

      setState(() {
        fotoBuku = XFile.fromData(bytes, name: 'cover_laskar_pelangi.jpg');
        fotoBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil cover: $e')));
    } finally {
      if (mounted) {
        setState(() {
          sedangMemuatCover = false;
        });
      }
    }
  }

  Future<void> simpanBuku() async {
    if (sedangMenyimpan || sedangMemuatCover) return;
    setState(() => sedangMenyimpan = true);
    try {
      await const BookService().save({
        'judul': judulController.text,
        'penulis': penulisController.text,
        'penerbit': penerbitController.text,
        'tahun_terbit': tahunController.text,
        'stok': stokController.text,
        'kategori': kategoriController.text,
      }, cover: fotoBytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan buku: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => sedangMenyimpan = false);
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    penulisController.dispose();
    penerbitController.dispose();
    tahunController.dispose();
    stokController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  Widget input({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
          filled: true,
          fillColor: const Color(0xFFF8F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 30,
                vertical: isMobile ? 16 : 30,
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 750),
                padding: EdgeInsets.all(isMobile ? 16 : 28),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Buku Baru',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Lengkapi informasi dan cover buku.',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 160,
                        height: 210,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: fotoBytes == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 55,
                                    color: Color(0xFFE85D75),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Belum ada cover',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                  fotoBytes!,
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 210,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image_outlined,
                                      size: 55,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: sedangMemuatCover ? null : pilihFoto,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Pilih Foto Buku'),
                          ),
                          OutlinedButton.icon(
                            onPressed: sedangMemuatCover
                                ? null
                                : gunakanCoverLaskarPelangi,
                            icon: sedangMemuatCover
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.auto_stories_outlined),
                            label: const Text('Cover Laskar Pelangi'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                input(
                  label: 'Judul Buku',
                  controller: judulController,
                  icon: Icons.menu_book_outlined,
                ),

                input(
                  label: 'Penulis',
                  controller: penulisController,
                  icon: Icons.person_outline,
                ),

                input(
                  label: 'Penerbit',
                  controller: penerbitController,
                  icon: Icons.business_outlined,
                ),

                Row(
                  children: [
                    Expanded(
                      child: input(
                        label: 'Tahun Terbit',
                        controller: tahunController,
                        icon: Icons.calendar_month_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: input(
                        label: 'Stok',
                        controller: stokController,
                        icon: Icons.inventory_2_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                input(
                  label: 'Kategori',
                  controller: kategoriController,
                  icon: Icons.category_outlined,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: sedangMenyimpan
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: sedangMenyimpan ? null : simpanBuku,
                        icon: sedangMenyimpan
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          sedangMenyimpan ? 'Menyimpan...' : 'Simpan Buku',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: const Color(0xFFE85D75),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);
  }
}
