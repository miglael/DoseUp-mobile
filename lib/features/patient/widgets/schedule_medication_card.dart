import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/medication_schedule_model.dart';

class ScheduleMedicationCard extends StatelessWidget {
  final MedicationScheduleModel medication;
  final VoidCallback onToggle;

  const ScheduleMedicationCard({
    super.key,
    required this.medication,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = medication.status == MedicationStatus.completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border, width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xFFDCE6FA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              medication.name == 'Amlodipine'
                  ? Icons.medication
                  : Icons.medication_outlined,
              color: AppTheme.primary,
              size: 32,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        medication.dosage,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(Icons.circle, size: 5, color: Colors.grey),
                    ),
                    const Icon(
                      Icons.restaurant,
                      size: 17,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        medication.instruction,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                medication.time,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF32968E)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isCompleted
                        ? null
                        : Border.all(color: const Color(0xFF788582), width: 2),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 29)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
