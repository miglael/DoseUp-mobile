import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/medication_schedule_model.dart';

class MedicationListItem extends StatelessWidget {
  final MedicationScheduleModel medication;

  const MedicationListItem({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final completed = medication.status == MedicationStatus.completed;
    final current = medication.status == MedicationStatus.current;
    final snoozed = medication.status == MedicationStatus.snoozed;

    final statusLabel = completed
        ? 'Selesai'
        : current
        ? 'Sekarang'
        : snoozed
        ? 'Ditunda'
        : 'Nanti';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: current || snoozed ? const Color(0xFF61D6C9) : AppTheme.border,
          width: current || snoozed ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: completed
                  ? const Color(0xFFE1EBE9)
                  : current || snoozed
                  ? AppTheme.primary
                  : const Color(0xFFDCE6FA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.check
                  : current || snoozed
                  ? Icons.medication
                  : Icons.medication_outlined,
              color: completed
                  ? Colors.grey
                  : current || snoozed
                  ? Colors.white
                  : AppTheme.textSecondary,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${medication.name} ${medication.dosage}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: completed ? Colors.grey : AppTheme.textPrimary,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medication.time,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: current ? FontWeight.w700 : FontWeight.w400,
              color: current ? AppTheme.primary : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
