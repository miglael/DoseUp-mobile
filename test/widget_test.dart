import 'package:doseup_project/features/auth/providers/auth_providers.dart';
import 'package:doseup_project/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:doseup_project/core/theme/app_theme.dart';
//import 'package:doseup_project/features/auth/providers/auth_provider.dart';
import 'package:doseup_project/features/auth/screens/login_screen.dart';

void main() {
  Widget createTestApp() {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }

  group('DoseUp Login Screen', () {
    testWidgets('menampilkan komponen halaman login', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());

      expect(find.text('Selamat Datang'), findsOneWidget);
      expect(find.text('Silakan masuk ke akun Anda'), findsOneWidget);
      expect(find.text('Saya Pasien'), findsOneWidget);
      expect(find.text('Saya Pendamping'), findsOneWidget);
      expect(find.text('Email atau Nomor Telepon'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
    });

    testWidgets('role Patient terpilih secara default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());

      final context = tester.element(find.byType(LoginScreen));
      final auth = Provider.of<AuthProvider>(context, listen: false);

      expect(auth.selectedRole, UserRole.patient);
    });

    testWidgets('pengguna dapat memilih role Guardian', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());

      await tester.tap(find.text('Saya Pendamping'));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginScreen));
      final auth = Provider.of<AuthProvider>(context, listen: false);

      expect(auth.selectedRole, UserRole.guardian);
    });

    testWidgets('login Patient menggunakan seed data berhasil', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.byType(TextField).at(0),
        'patient@doseup.demo',
      );
      await tester.enterText(find.byType(TextField).at(1), 'DoseUp123!');

      await tester.ensureVisible(find.text('Masuk'));
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(find.text('Login Berhasil'), findsOneWidget);
      expect(find.textContaining('Demo Patient'), findsOneWidget);
    });

    testWidgets('login gagal jika password salah', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(
        find.byType(TextField).at(0),
        'patient@doseup.demo',
      );
      await tester.enterText(find.byType(TextField).at(1), 'password-salah');

      await tester.ensureVisible(find.text('Masuk'));
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(
        find.text('Akun tidak ditemukan atau data login tidak sesuai.'),
        findsOneWidget,
      );
    });
  });
}
