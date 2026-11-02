import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AllCompletedCard extends StatelessWidget {
  const AllCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text(
            'Semua jadwal obat selesai!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
