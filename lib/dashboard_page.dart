import 'package:flutter/material.dart';

import 'books/book_list_page.dart';
import 'profiles/profile1_page.dart';
import 'profiles/profile2_page.dart';
import 'profiles/profile3_page.dart';
import 'profiles/profile4_page.dart';
import 'profiles/profile5_page.dart';
import 'services/auth_service.dart';
import 'services/book_service.dart';

const _pageBackground = Color(0xFFF5F7FB);
const _textColor = Color(0xFF403B4B);
const _accent = Color(0xFFE85D75);
const _sidebarGradient = LinearGradient(
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
);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool profilAnggotaTerbuka = false;
  bool _loggingOut = false;
  List<dynamic> bukuTerbaru = [];
  bool loadingBuku = true;

  @override
  void initState() {
    super.initState();
    _ambilBukuTerbaru();
  }

  Future<void> _ambilBukuTerbaru() async {
    try {
      final books = await const BookService().list(limit: 5);
      if (!mounted) return;
      setState(() {
        bukuTerbaru = books;
        loadingBuku = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingBuku = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat buku: $e')));
    }
  }

  void _closeDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  Future<void> _openPage(Widget page, {bool refreshBooks = false}) async {
    _closeDrawer();
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => page));
    if (mounted && refreshBooks) await _ambilBukuTerbaru();
  }

  Future<void> _logout() async {
    if (_loggingOut) return;
    _closeDrawer();
    setState(() => _loggingOut = true);
    try {
      await const AuthService().logout();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
    } finally {
      if (mounted) setState(() => _loggingOut = false);
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Selamat Pagi';
    if (hour >= 11 && hour < 15) return 'Selamat Siang';
    if (hour >= 15 && hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Widget _navigation() {
    const profiles = <Widget>[
      Profile1Page(),
      Profile2Page(),
      Profile3Page(),
      Profile4Page(),
      Profile5Page(),
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: _sidebarGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/background/logo_rpl.jpeg',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Text(
                      'Sistem Buku',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            SidebarMenu(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              aktif: true,
              onTap: _closeDrawer,
            ),
            SidebarMenu(
              icon: Icons.library_books_outlined,
              title: 'Data Buku',
              onTap: () => _openPage(const BookListPage(), refreshBooks: true),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: Color(0x664B4658)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Text(
                'PROFIL ANGGOTA',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xB34B4658),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SidebarMenu(
              icon: Icons.people_outline,
              title: 'Profil Anggota',
              trailing: Icon(
                profilAnggotaTerbuka
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF4B4658),
              ),
              onTap: () =>
                  setState(() => profilAnggotaTerbuka = !profilAnggotaTerbuka),
            ),
            if (profilAnggotaTerbuka)
              for (var i = 0; i < profiles.length; i++)
                SidebarMenu(
                  icon: Icons.person_outline,
                  title: 'Profil ${i + 1}',
                  onTap: () => _openPage(profiles[i]),
                ),
            const SizedBox(height: 24),
            SidebarMenu(
              icon: Icons.logout_rounded,
              title: _loggingOut ? 'Keluar...' : 'Logout',
              warna: Colors.redAccent,
              onTap: _loggingOut ? null : _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDF2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_greeting,',
                            style: const TextStyle(
                              color: _textColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Admin \u{1F44B}',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Semoga harimu menyenangkan!',
                            style: TextStyle(
                              color: Color(0xFF796A75),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (constraints.maxWidth >= 280 * scale) ...[
                      const SizedBox(width: 12),
                      const ExcludeSemantics(child: _BookDecoration()),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const _MobileSummary(),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '\u26A1 Menu Cepat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Akses fitur utama dengan cepat.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF827A88)),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final scale =
                        MediaQuery.textScalerOf(context).scale(14) / 14;
                    return _ResponsiveCards(
                      horizontal: constraints.maxWidth >= 280 * scale,
                      spacing: 10,
                      children: [
                        _MobileQuickMenu(
                          icon: Icons.library_books_outlined,
                          title: 'Data Buku',
                          subtitle: 'Tambah, edit dan hapus buku.',
                          color: _accent,
                          background: const Color(0xFFFFF0F4),
                          onTap: () => _openPage(
                            const BookListPage(),
                            refreshBooks: true,
                          ),
                        ),
                        _MobileQuickMenu(
                          icon: Icons.person_outline,
                          title: 'Profil 1',
                          subtitle: 'Lihat portfolio anggota.',
                          color: const Color(0xFF8470BD),
                          background: const Color(0xFFF4F0FC),
                          onTap: () => _openPage(const Profile1Page()),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDF2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _accent, size: 24),
                SizedBox(height: 10),
                Text(
                  'Sistem Data Buku',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sistem Data Buku digunakan untuk mengelola data buku dan menampilkan profil anggota kelompok.',
                  style: TextStyle(
                    color: Color(0xFF796A75),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(bool desktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = desktop ? 35.0 : 16.0;
        final contentWidth = constraints.maxWidth - padding * 2;
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final horizontalCards = desktop && contentWidth >= 900 * textScale;
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(desktop && contentWidth >= 600 * textScale),
              const SizedBox(height: 30),
              _ResponsiveCards(
                horizontal: horizontalCards,
                children: const [
                  DashboardCard(
                    icon: Icons.library_books_outlined,
                    title: 'Data Buku',
                    value: 'CRUD',
                    warna: _accent,
                    background: Color(0xFFFFE8EC),
                  ),
                  DashboardCard(
                    icon: Icons.people_outline,
                    title: 'Profil Anggota',
                    value: '5',
                    warna: Color(0xFF4F46E5),
                    background: Color(0xFFEDE9FE),
                  ),
                  DashboardCard(
                    icon: Icons.check_circle_outline,
                    title: 'Status Sistem',
                    value: 'Aktif',
                    warna: Color(0xFF16A34A),
                    background: Color(0xFFDCFCE7),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(desktop ? 28 : 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Menu Cepat',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pilih menu untuk mengelola sistem.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),
                    _ResponsiveCards(
                      horizontal: desktop && contentWidth >= 750 * textScale,
                      children: [
                        QuickMenu(
                          icon: Icons.library_books_outlined,
                          title: 'Data Buku',
                          subtitle: 'Tambah, edit dan hapus buku',
                          onTap: () => _openPage(
                            const BookListPage(),
                            refreshBooks: true,
                          ),
                        ),
                        QuickMenu(
                          icon: Icons.person_outline,
                          title: 'Profil 1',
                          subtitle: 'Lihat portfolio anggota',
                          onTap: () => _openPage(const Profile1Page()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(desktop ? 25 : 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8EC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: _ResponsiveCards(
                  horizontal: desktop,
                  expandChildren: false,
                  spacing: 15,
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.info_outline, color: _accent, size: 35),
                    ),
                    Text(
                      'Sistem Data Buku digunakan untuk mengelola data buku dan menampilkan profil anggota kelompok.',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(bool horizontal) {
    return _ResponsiveCards(
      horizontal: horizontal,
      expandChildren: false,
      expandFirst: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$_greeting di Sistem Data Buku \u{1F44B}',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFFFE8EC),
                  child: Icon(Icons.person_outline, color: _accent),
                ),
                SizedBox(width: 10),
                Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1000;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: desktop ? _pageBackground : const Color(0xFFFFFAFB),
          appBar: desktop
              ? null
              : AppBar(
                  backgroundColor: const Color(0xFFFFFAFC),
                  foregroundColor: _textColor,
                  elevation: 0,
                  toolbarHeight: 56,
                  scrolledUnderElevation: 0,
                  titleSpacing: 0,
                  title: const Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: _accent, size: 22),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Sistem Buku',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: IconButton(
                    tooltip: 'Buka menu',
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
          drawer: desktop
              ? null
              : Drawer(
                  width: constraints.maxWidth < 360
                      ? constraints.maxWidth * 0.9
                      : 300,
                  child: _navigation(),
                ),
          bottomNavigationBar: desktop
              ? null
              : BottomNavigationBar(
                  currentIndex: 0,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: _accent,
                  unselectedItemColor: const Color(0xFF928996),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  elevation: 4,
                  onTap: (index) {
                    if (index == 0) {
                      _closeDrawer();
                    } else {
                      _openPage(const BookListPage(), refreshBooks: true);
                    }
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: 'Beranda',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      label: 'Data Buku',
                    ),
                  ],
                ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (desktop) SizedBox(width: 250, child: _navigation()),
              Expanded(
                child: SafeArea(
                  child: desktop ? _content(true) : _mobileContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponsiveCards extends StatelessWidget {
  final bool horizontal;
  final List<Widget> children;
  final double spacing;
  final bool expandChildren;
  final bool expandFirst;

  const _ResponsiveCards({
    required this.horizontal,
    required this.children,
    this.spacing = 18,
    this.expandChildren = true,
    this.expandFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!horizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          if (expandChildren ||
              (expandFirst ? i == 0 : i == children.length - 1))
            Expanded(child: children[i])
          else
            children[i],
        ],
      ],
    );
  }
}

class SidebarMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool aktif;
  final Color? warna;
  final Widget? trailing;

  const SidebarMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.aktif = false,
    this.warna,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Material(
        color: aktif ? Colors.white.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.white.withValues(alpha: 0.32),
          splashColor: Colors.white.withValues(alpha: 0.38),
          highlightColor: Colors.white.withValues(alpha: 0.24),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: warna ?? const Color(0xFF4B4658), size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: warna ?? _textColor,
                      fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color warna;
  final Color background;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.warna,
    required this.background,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: widget.warna.withValues(alpha: _isHover ? 0.2 : 0.05),
              blurRadius: _isHover ? 20 : 18,
              offset: Offset(0, _isHover ? 12 : 8),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: _isHover ? widget.warna : widget.background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                widget.icon,
                color: _isHover ? Colors.white : widget.warna,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        hoverColor: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _accent),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileSummary extends StatelessWidget {
  const _MobileSummary();

  @override
  Widget build(BuildContext context) {
    const cards = [
      (
        title: 'Data Buku',
        value: 'CRUD',
        icon: Icons.library_books_outlined,
        color: _accent,
        background: Color(0xFFFFE8EF),
      ),
      (
        title: 'Profil Anggota',
        value: '5',
        icon: Icons.people_outline,
        color: Color(0xFF8470BD),
        background: Color(0xFFEFE9FA),
      ),
      (
        title: 'Status Sistem',
        value: 'Aktif',
        icon: Icons.check_circle_outline,
        color: Color(0xFF51976B),
        background: Color(0xFFE5F4E9),
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(12) / 12;
        final minimumWidth = 104.0 * scale;
        final availableWidth = (constraints.maxWidth - 16) / 3;
        final width = availableWidth < minimumWidth
            ? minimumWidth
            : availableWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(Colors.white, cards[i].background, 0.35)!,
                        cards[i].background,
                      ],
                    ),
                    border: Border.all(
                      color: cards[i].color.withValues(alpha: 0.07),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cards[i].color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          cards[i].icon,
                          color: cards[i].color,
                          size: 23,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cards[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: _textColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cards[i].value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MobileQuickMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  const _MobileQuickMenu({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.12),
                  ),
                  child: Icon(icon, color: color, size: 29),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF827A88),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small decorative book stack drawn with Flutter widgets; no remote assets.
class _BookDecoration extends StatelessWidget {
  const _BookDecoration();

  Widget _book(Color color, double angle) => Transform.rotate(
    angle: angle,
    child: Container(
      width: 78,
      height: 29,
      padding: const EdgeInsets.fromLTRB(12, 5, 3, 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 88,
    height: 106,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          right: 4,
          child: Transform.rotate(
            angle: 0.3,
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF9CCEA8),
              size: 42,
            ),
          ),
        ),
        Positioned(
          left: 5,
          bottom: 4,
          child: _book(const Color(0xFF9481CA), 0.08),
        ),
        Positioned(
          left: 0,
          bottom: 32,
          child: _book(const Color(0xFFEF91AD), -0.12),
        ),
      ],
    ),
  );
}
