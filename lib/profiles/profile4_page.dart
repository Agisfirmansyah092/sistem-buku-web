import 'package:flutter/material.dart';

import 'profile_template.dart';

class Profile4Page extends StatelessWidget {
  const Profile4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTemplate(
      nama: 'Muhammad Ridho Alfauzaan',
      jenisKelamin: 'Laki-Laki',
      jabatan: 'Content Creator Pemula',
      telepon: '083456789012',
      email: 'muhammadridhoalfauzaan@email.com',
      tentang:
          'Pelajar kreatif yang memiliki minat pada penulisan, fotografi, dan pembuatan konten digital yang informatif.',
      keahlian: [
        'Menulis',
        'Fotografi',
        'Editing Video',
        'Copywriting',
        'Kreativitas',
      ],
      proyek: [
        'Konten media sosial sekolah',
        'Video dokumentasi kegiatan',
        'Majalah digital kelas',
      ],
      pendidikan:
          'SMK Negeri 1 Leuwimunding, Rekayasa Perangkat Lunak | 2024 - 2026',
      pengalaman:
          'Mengelola konten media sosial kelas dan menjadi dokumentasi kegiatan sekolah.',
      pencapaian: [
        'Penghargaan konten kreatif terbaik',
        'Sertifikat editing video dasar',
      ],
      bahasa: ['Bahasa Indonesia', 'Bahasa Inggris Dasar'],
      backgroundUrl: 'assets/library_background.svg',
      fotoAsset: 'assets/profiles/ridhp.jpg',
      warna: Color(0xFFE85D75),
    );
  }
}
