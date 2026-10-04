import 'package:flutter/material.dart';

import 'profile_template.dart';

class Profile3Page extends StatelessWidget {
  const Profile3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileTemplate(
      nama: 'Neng Citra Mutiara',
      jenisKelamin: 'Perempuan',
      jabatan: 'Web Developer Pemula',
      telepon: '082345678901',
      email: 'nengcitramutiara@email.com',
      tentang:
          'Pelajar yang senang membangun website sederhana, mengolah data, dan belajar teknologi pemrograman terbaru.',
      keahlian: ['HTML', 'CSS', 'PHP', 'MySQL', 'JavaScript'],
      proyek: [
        'Website profil sekolah',
        'Sistem data siswa',
        'Landing page kegiatan',
      ],
      pendidikan:
          'SMK Negeri 1 Leuwimunding, Rekayasa Perangkat Lunak | 2024 - 2026',
      pengalaman:
          'Praktik membuat website informasi sekolah dan membantu pemeliharaan database kelas.',
      pencapaian: [
        'Juara 2 lomba website antarkelas',
        'Sertifikat dasar PHP dan MySQL',
      ],
      bahasa: ['Bahasa Indonesia', 'Bahasa Inggris Menengah'],
      backgroundUrl: 'assets/library_background.svg',
      fotoAsset: 'assets/profiles/citra.jpg',
      warna: Color(0xFF0F766E),
    );
  }
}
