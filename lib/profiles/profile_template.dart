import 'dart:ui';

import 'package:flutter/material.dart';
import 'tilt_card_3d.dart';

class ProfileTemplate extends StatelessWidget {
  final String nama;
  final String jenisKelamin;
  final String jabatan;
  final String telepon;
  final String email;
  final String tentang;
  final List<String> keahlian;
  final List<String> proyek;
  final String pendidikan;
  final String pengalaman;
  final List<String> pencapaian;
  final List<String> bahasa;
  final String backgroundUrl;
  final String? fotoAsset;
  final Color warna;

  const ProfileTemplate({
    super.key,
    required this.nama,
    required this.jenisKelamin,
    required this.jabatan,
    required this.telepon,
    required this.email,
    required this.tentang,
    required this.keahlian,
    required this.proyek,
    required this.pendidikan,
    required this.pengalaman,
    required this.pencapaian,
    required this.bahasa,
    required this.backgroundUrl,
    this.fotoAsset,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4CFE0),
      appBar: AppBar(
        title: const Text(
          'Curriculum Vitae',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF4CFE0),
        foregroundColor: const Color(0xFF403B4B),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Color(0xFF16A34A)),
                SizedBox(width: 7),
                Text(
                  'Tersedia',
                  style: TextStyle(
                    color: Color(0xFF15803D),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
              final isMobile = constraints.maxWidth < 600;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 24,
                  vertical: isMobile ? 18 : 38,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Column(
                      children: [
                        TiltCard3D(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(isMobile ? 16 : 28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.5),
                                  Color.lerp(
                                    Colors.white,
                                    warna,
                                    0.12,
                                  )!.withValues(alpha: 0.32),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.34),
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x24111827),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 58,
                                      backgroundColor: Colors.white,
                                      backgroundImage: fotoAsset == null
                                          ? null
                                          : AssetImage(fotoAsset!),
                                      child: fotoAsset == null
                                          ? Icon(
                                              jenisKelamin == 'Laki-laki'
                                                  ? Icons.person
                                                  : Icons.person_2,
                                              size: 64,
                                              color: warna,
                                            )
                                          : null,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  jenisKelamin.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF5A536B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  nama,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF403B4B),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  jabatan,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF5A536B),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _ContactChip(
                                      icon: Icons.phone,
                                      text: telepon,
                                    ),
                                    _ContactChip(
                                      icon: Icons.email,
                                      text: email,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            label: 'PROFIL',
                            value: 'AKTIF',
                            warna: warna,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            label: 'KEAHLIAN',
                            value: '${keahlian.length}',
                            warna: warna,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            label: 'PROYEK',
                            value: '${proyek.length}',
                            warna: warna,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _SectionCard(
                      title: 'Tentang Saya',
                      icon: Icons.person_outline,
                      warna: warna,
                      child: Text(
                        tentang,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          height: 1.6,
                          color: Color(0xFF403B4B),
                          shadows: [
                            Shadow(color: Color(0x66000000), blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SectionCard(
                      title: 'Keahlian Utama',
                      icon: Icons.star_outline,
                      warna: warna,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: keahlian
                            .map(
                              (item) => Chip(
                                avatar: Icon(
                                  Icons.bolt,
                                  size: 16,
                                  color: warna,
                                ),
                                label: Text(item),
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.28),
                                ),
                                labelStyle: const TextStyle(
                                  color: Color(0xFF403B4B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SectionCard(
                      title: 'Pendidikan & Pengalaman',
                      icon: Icons.school_outlined,
                      warna: warna,
                      child: Column(
                        children: [
                          _TimelineItem(
                            icon: Icons.school_outlined,
                            title: 'Pendidikan',
                            description: pendidikan,
                            warna: warna,
                          ),
                          _TimelineItem(
                            icon: Icons.work_outline,
                            title: 'Pengalaman',
                            description: pengalaman,
                            warna: warna,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SectionCard(
                      title: 'Proyek Pilihan',
                      icon: Icons.folder_open_outlined,
                      warna: warna,
                      child: Column(
                        children: List.generate(
                          proyek.length,
                          (index) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 17,
                              backgroundColor: warna.withValues(alpha: 0.1),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: warna,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              proyek[index],
                              style: const TextStyle(
                                color: Color(0xFF403B4B),
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Color(0x66000000),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SectionCard(
                      title: 'Pencapaian & Bahasa',
                      icon: Icons.emoji_events_outlined,
                      warna: warna,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...pencapaian.map(
                            (item) => _InfoLine(
                              icon: Icons.verified_outlined,
                              text: item,
                              warna: warna,
                            ),
                          ),
                          Divider(
                            height: 24,
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: bahasa
                                .map(
                                  (item) => Chip(
                                    label: Text(item),
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.15,
                                    ),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF403B4B),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Kembali ke Dashboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warna,
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

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: const Color(0xFF6D4FA3)),
      label: Text(text),
      backgroundColor: Colors.white.withValues(alpha: 0.16),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      labelStyle: const TextStyle(
        color: Color(0xFF403B4B),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color warna;

  const _StatBox({
    required this.label,
    required this.value,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18111827),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: warna,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF403B4B),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color warna;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: warna),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF403B4B),
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Color(0x66000000), blurRadius: 3)],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF5A536B),
                    height: 1.45,
                    shadows: [Shadow(color: Color(0x55000000), blurRadius: 3)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color warna;

  const _InfoLine({
    required this.icon,
    required this.text,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: warna),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF5A536B),
                height: 1.4,
                shadows: [Shadow(color: Color(0x55000000), blurRadius: 3)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color warna;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.warna,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.27),
                Colors.white.withValues(alpha: 0.16),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18111827),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: warna.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, color: warna, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF403B4B),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Color(0x66000000), blurRadius: 3),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
