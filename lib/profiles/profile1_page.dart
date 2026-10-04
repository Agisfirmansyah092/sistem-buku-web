import 'package:flutter/material.dart';
import 'tilt_card_3d.dart';

class Profile1Page extends StatelessWidget {
  const Profile1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(
        title: const Text(
          'Curriculum Vitae',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 9, color: Color(0xFF16A34A)),
                SizedBox(width: 7),
                Text(
                  'Siap Berkembang',
                  style: TextStyle(
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFC9D5F2),
                    Color(0xFFD8CFF0),
                    Color(0xFFF4CFE0),
                    Color(0xFFF8D7E5),
                    Color(0xFFD5E4F3),
                    Color(0xFFD8EFE5),
                  ],
                  stops: [0.0, 0.2, 0.42, 0.58, 0.8, 1.0],
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool layarLebar = constraints.maxWidth >= 850;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: layarLebar ? 50 : 18,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1150),
                    child: Column(
                      children: [
                        layarLebar
                            ? const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: KolomKiri()),
                                  SizedBox(width: 24),
                                  Expanded(flex: 4, child: KolomKanan()),
                                ],
                              )
                            : const Column(
                                children: [
                                  KolomKiri(),
                                  SizedBox(height: 22),
                                  KolomKanan(),
                                ],
                              ),
                        const SizedBox(height: 28),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Kembali ke Dashboard'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE85D75),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// KOLOM KIRI
// =====================================================
class KolomKiri extends StatelessWidget {
  const KolomKiri({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TiltCard3D(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF102A43), Color(0xFF243B53)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40102A43),
                  blurRadius: 30,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://i.ibb.co.com/d46cSWXY/agis.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'Muhamad Al Agis Firmansyah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Pelajar & Mobile Developer Pemula',
                  style: TextStyle(fontSize: 16, color: Color(0xFFB7E4C7)),
                ),

                const SizedBox(height: 24),

                const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    KontakChip(
                      icon: Icons.phone_outlined,
                      teks: '085723713943',
                    ),
                    KontakChip(
                      icon: Icons.email_outlined,
                      teks: 'agisfirmansyah092@gmail.com',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),

        const SectionCard(
          icon: Icons.person_outline_rounded,
          judul: 'Tentang Saya',
          child: Text(
            'Saya adalah siswa SMK kelas 12 jurusan Rekayasa Perangkat '
            'Lunak yang memiliki minat kuat dalam pengembangan aplikasi '
            'mobile dan website. Saya terbiasa mempelajari teknologi baru, '
            'menyelesaikan pekerjaan secara teliti, serta membangun aplikasi '
            'yang responsif dan mudah digunakan.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.7,
              fontSize: 15,
              color: Color(0xFF4B5563),
            ),
          ),
        ),

        const SizedBox(height: 22),

        const SectionCard(
          icon: Icons.folder_open_outlined,
          judul: 'Proyek Pilihan',
          child: Column(
            children: [
              PortfolioItem(
                icon: Icons.login_rounded,
                judul: 'Aplikasi Login Flutter',
                deskripsi:
                    'Membangun autentikasi dan navigasi menuju dashboard menggunakan Flutter.',
              ),
              Divider(height: 26),

              PortfolioItem(
                icon: Icons.badge_outlined,
                judul: 'Aplikasi Curriculum Vitae',
                deskripsi:
                    'Merancang halaman CV profesional yang responsif untuk desktop dan mobile.',
              ),
              Divider(height: 26),

              PortfolioItem(
                icon: Icons.web_outlined,
                judul: 'Website Sekolah',
                deskripsi:
                    'Membuat website informatif menggunakan HTML, CSS, PHP, dan MySQL.',
              ),
              Divider(height: 26),

              PortfolioItem(
                icon: Icons.point_of_sale_outlined,
                judul: 'Aplikasi Kasir',
                deskripsi:
                    'Mengembangkan fitur pencatatan produk dan transaksi secara terstruktur.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// KOLOM KANAN
// =====================================================
class KolomKanan extends StatelessWidget {
  const KolomKanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          icon: Icons.star_outline_rounded,
          judul: 'Keahlian Utama',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              SkillChip(teks: 'Flutter'),
              SkillChip(teks: 'Dart'),
              SkillChip(teks: 'HTML'),
              SkillChip(teks: 'CSS'),
              SkillChip(teks: 'PHP'),
              SkillChip(teks: 'MySQL'),
              SkillChip(teks: 'UI/UX Design'),
              SkillChip(teks: 'Git'),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const SectionCard(
          icon: Icons.work_outline_rounded,
          judul: 'Pengalaman Proyek',
          child: PengalamanItem(
            posisi: 'Pengembangan Sistem Data Buku',
            perusahaan: 'Proyek Pembelajaran Mandiri',
            tahun: '2026',
            deskripsi:
                'Membangun aplikasi Flutter yang terhubung dengan API PHP '
                'dan database MySQL. Mengembangkan fitur login, registrasi, '
                'dashboard, serta pengelolaan data buku.',
          ),
        ),

        const SizedBox(height: 22),

        const SectionCard(
          icon: Icons.school_outlined,
          judul: 'Pendidikan',
          child: PendidikanItem(
            jenjang: 'Siswa SMK Kelas 12',
            sekolah: 'Jurusan Rekayasa Perangkat Lunak',
            tahun: 'Sekarang',
            deskripsi:
                'Mempelajari dasar pemrograman, pembuatan website, database, '
                'dan pengembangan aplikasi mobile menggunakan Flutter.',
          ),
        ),

        const SizedBox(height: 22),

        const SectionCard(
          icon: Icons.contact_phone_outlined,
          judul: 'Kontak',
          child: Column(
            children: [
              InfoKontak(
                icon: Icons.phone_outlined,
                judul: 'Nomor Telepon',
                isi: '085723713943',
              ),
              SizedBox(height: 16),
              InfoKontak(
                icon: Icons.email_outlined,
                judul: 'Email',
                isi: 'agisfirmansyah092@gmail.com',
              ),
              SizedBox(height: 16),
              InfoKontak(
                icon: Icons.location_on_outlined,
                judul: 'Alamat',
                isi: 'Majalengka, Jawa Barat',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// SECTION CARD
// =====================================================
class SectionCard extends StatelessWidget {
  final IconData icon;
  final String judul;
  final Widget child;

  const SectionCard({
    super.key,
    required this.icon,
    required this.judul,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4ED),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: const Color(0xFF2F855A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// =====================================================
// KONTAK CHIP
// =====================================================
class KontakChip extends StatelessWidget {
  final IconData icon;
  final String teks;

  const KontakChip({super.key, required this.icon, required this.teks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 8),
          Text(teks, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// =====================================================
// SKILL CHIP
// =====================================================
class SkillChip extends StatelessWidget {
  final String teks;

  const SkillChip({super.key, required this.teks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

// =====================================================
// PORTFOLIO ITEM
// =====================================================
class PortfolioItem extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String deskripsi;

  const PortfolioItem({
    super.key,
    required this.icon,
    required this.judul,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4ED),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 21, color: const Color(0xFF2F855A)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                deskripsi,
                style: const TextStyle(height: 1.5, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// PENGALAMAN ITEM
// =====================================================
class PengalamanItem extends StatelessWidget {
  final String posisi;
  final String perusahaan;
  final String tahun;
  final String deskripsi;

  const PengalamanItem({
    super.key,
    required this.posisi,
    required this.perusahaan,
    required this.tahun,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                posisi,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4ED),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                tahun,
                style: const TextStyle(
                  color: Color(0xFF2F855A),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          perusahaan,
          style: const TextStyle(
            color: Color(0xFF2F855A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          deskripsi,
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.6, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

// =====================================================
// PENDIDIKAN ITEM
// =====================================================
class PendidikanItem extends StatelessWidget {
  final String jenjang;
  final String sekolah;
  final String tahun;
  final String deskripsi;

  const PendidikanItem({
    super.key,
    required this.jenjang,
    required this.sekolah,
    required this.tahun,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                jenjang,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tahun,
                style: const TextStyle(
                  color: Color(0xFF15803D),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          sekolah,
          style: const TextStyle(
            color: Color(0xFF2F855A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          deskripsi,
          textAlign: TextAlign.justify,
          style: const TextStyle(height: 1.6, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

// =====================================================
// INFO KONTAK
// =====================================================
class InfoKontak extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String isi;

  const InfoKontak({
    super.key,
    required this.icon,
    required this.judul,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4ED),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFF2F855A), size: 21),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
              const SizedBox(height: 3),
              Text(
                isi,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
