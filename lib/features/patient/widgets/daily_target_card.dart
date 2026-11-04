import 'package:doseup_project/features/patient/providers/medication_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

// import '../providers/medication_provider.dart';
//import 'package:';

class DailyTargetCard extends StatelessWidget {
  final MedicationProvider provider;

  const DailyTargetCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    const demoTarget = 5;

    final completed = provider.completedCount >= 1
        ? (provider.completedCount + 3).clamp(0, demoTarget)
        : 4;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: completed / demoTarget,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.butt,
                    backgroundColor: const Color(0xFFE1ECE9),
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  '${(completed / demoTarget * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Harian',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completed dari $demoTarget aktivitas selesai',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
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
