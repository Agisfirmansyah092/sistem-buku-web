import 'package:flutter/material.dart';

import 'profile_template.dart';

class Profile5Page extends StatelessWidget {
  const Profile5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTemplate(
      nama: 'Widia Hassanah',
      jenisKelamin: 'Perempuan',
      jabatan: 'Database Administrator Pemula',
      telepon: '084567890123',
      email: 'widiahassanah@email.com',
      tentang:
          'Pelajar yang tertarik pada pengelolaan database, analisis data, dan pengembangan sistem informasi yang terstruktur.',
      keahlian: [
        'MySQL',
        'Database',
        'PHP',
        'Analisis Data',
        'Problem Solving',
      ],
      proyek: [
        'Database perpustakaan',
        'Sistem inventaris kelas',
        'Laporan data penjualan',
      ],
      pendidikan:
          'SMK Negeri 1 Leuwimunding, Rekayasa Perangkat Lunak | 2024 - 2026',
      pengalaman:
          'Menyusun struktur database untuk proyek perpustakaan dan membuat laporan data sederhana.',
      pencapaian: [
        'Sertifikat pengelolaan database dasar',
        'Peserta terbaik proyek sistem informasi',
      ],
      bahasa: ['Bahasa Indonesia', 'Bahasa Inggris Dasar'],
      backgroundUrl: 'assets/library_background.svg',
      fotoAsset: 'assets/profiles/widia.jpg',
      warna: Color(0xFF2563EB),
    );
  }
}
