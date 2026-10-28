import 'package:doseup_project/features/auth/providers/auth_providers.dart';
import 'package:doseup_project/features/auth/screens/patient_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/role_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final authProvider = context.read<AuthProvider>();

    final success = authProvider.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login gagal.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    final user = authProvider.currentUser!;

    if (user.role == UserRole.patient) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PatientDashboardScreen()),
      );
    } else {
      _showMessageForGuardian();
    }
  }

  void _showLoginSuccess(UserModel user) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            color: AppTheme.primary,
            size: 48,
          ),
          title: const Text('Login Berhasil'),
          content: Text(
            'Selamat datang, ${user.name}!\n\n'
            'Role: ${user.role == UserRole.patient ? 'Pasien' : 'Pendamping'}\n\n'
            'Login ini masih menggunakan data demo lokal.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  void _showMessageForGuardian() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dashboard Pendamping akan dibuat pada tahap berikutnya.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 44, 24, 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFC8E6E3),
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ],
                        stops: [0.0, 0.28, 0.65, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFE6ECEA),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Silakan masuk ke akun Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppTheme.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 36),

                        RoleSelector(
                          selectedRole: authProvider.selectedRole,
                          onChanged: (role) {
                            context.read<AuthProvider>().selectRole(role);
                          },
                        ),

                        const SizedBox(height: 34),

                        AuthTextField(
                          label: 'Email atau Nomor Telepon',
                          hint: 'Masukkan email atau no. HP',
                          controller: _identifierController,
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            context.read<AuthProvider>().clearError();
                          },
                        ),

                        const SizedBox(height: 22),

                        AuthTextField(
                          label: 'Kata Sandi',
                          hint: 'Masukkan kata sandi',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          onChanged: (_) {
                            context.read<AuthProvider>().clearError();
                          },
                          suffixIcon: IconButton(
                            tooltip: _isPasswordVisible
                                ? 'Sembunyikan kata sandi'
                                : 'Tampilkan kata sandi',
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.textSecondary,
                              size: 25,
                            ),
                          ),
                        ),

                        const SizedBox(height: 34),

                        SizedBox(
                          height: 58,
                          child: FilledButton(
                            onPressed: _handleLogin,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fitur pendaftaran akan dibuat pada tahap berikutnya.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                          ),
                          child: const Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
