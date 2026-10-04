import 'package:flutter/material.dart';

import 'profile_template.dart';

class Profile2Page extends StatelessWidget {
  const Profile2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTemplate(
      nama: 'Indri Anggraini Aprilia',
      jenisKelamin: 'Perempuan',
      jabatan: 'UI/UX Designer Pemula',
      telepon: '0881023654859',
      email: 'indrianggrainiaprilia@email.com',
      tentang:
          'Siswi SMK yang tertarik pada desain antarmuka, riset pengguna, dan pembuatan aplikasi yang mudah digunakan.',
      keahlian: ['Menggambar', 'UI Design', 'Wireframe', 'Canva', 'Presentasi'],
      proyek: [
        'Desain aplikasi perpustakaan',
        'Prototype aplikasi kasir',
        'Poster promosi sekolah',
      ],
      pendidikan:
          'SMK Negeri 1 Leuwimunding, Rekayasa Perangkat Lunak | 2024 - 2026',
      pengalaman:
          'Tim desain proyek aplikasi sekolah dan koordinator presentasi kelompok.',
      pencapaian: [
        'Finalis lomba desain poster pelajar',
        'Sertifikat dasar UI/UX Design',
      ],
      bahasa: ['Bahasa Indonesia', 'Bahasa Inggris Dasar'],
      backgroundUrl: 'assets/library_background.svg',
      fotoAsset: 'assets/profiles/indri.jpg',
      warna: Color(0xFF7C3AED),
    );
  }
}
