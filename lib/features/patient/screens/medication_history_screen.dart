import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MedicationHistoryScreen extends StatelessWidget {
  const MedicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FE),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 60, color: AppTheme.primary),
              SizedBox(height: 16),
              Text(
                'Riwayat Obat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text('Halaman dalam pengembangan'),
            ],
          ),
        ),
      ),
    );
  }
}
