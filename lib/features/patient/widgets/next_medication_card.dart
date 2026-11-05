import 'package:doseup_project/models/medication_schedule_view_model.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class NextMedicationCard extends StatelessWidget {
  final MedicationScheduleViewModel medication;
  final VoidCallback onTaken;
  final VoidCallback onSnooze;

  const NextMedicationCard({
    super.key,
    required this.medication,
    required this.onTaken,
    required this.onSnooze,
  });

  @override
  Widget build(BuildContext context) {
    final isSnoozed = medication.status == MedicationStatus.snoozed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF008577),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0x337FFFFFFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'JADWAL SELANJUTNYA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${medication.name} ${medication.dosage}',
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            medication.time,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (medication.instruction.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              medication.instruction,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFE2F5F2),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton.icon(
              onPressed: onTaken,
              icon: const Icon(Icons.check_circle, color: AppTheme.primary),
              label: const Text('Selesai Diminum'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton.icon(
              onPressed: isSnoozed ? null : onSnooze,
              icon: const Icon(Icons.alarm),
              label: Text(isSnoozed ? 'Pengingat Ditunda' : 'Tunda 10 Menit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0x66FFFFFF), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
