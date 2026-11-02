import 'package:doseup_project/features/auth/providers/auth_providers.dart';
import 'package:doseup_project/features/auth/providers/medication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
//import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';

//import 'features/patient/providers/medication_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
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
