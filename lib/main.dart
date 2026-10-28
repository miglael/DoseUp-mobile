import 'package:doseup_project/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
//import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const DoseUpApp(),
    ),
  );
}

class DoseUpApp extends StatelessWidget {
  const DoseUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoseUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
