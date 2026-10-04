import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistem_buku/login_page.dart';

void main() {
  testWidgets('Login kosong tidak membuka dashboard', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.tap(find.text('LOGIN'));
    await tester.pump();
    expect(find.text('Email dan password wajib diisi.'), findsOneWidget);
    expect(find.text('Selamat Datang'), findsOneWidget);
  });

  testWidgets('Registrasi kosong ditolak', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('DAFTAR'));
    await tester.pump();
    expect(find.text('Semua data wajib diisi.'), findsOneWidget);
    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });
}
