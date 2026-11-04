import 'package:doseup_project/features/patient/providers/medication_provider.dart';
import 'package:doseup_project/features/patient/screens/medication_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_bottom_navbar.dart';

//import '../providers/medication_provider.dart';
import '../widgets/daily_target_card.dart';
import '../widgets/next_medication_card.dart';
import '../widgets/medication_list_item.dart';
import '../widgets/all_completed_card.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final medicationProvider = context.watch<MedicationProvider>();
    final current = medicationProvider.currentMedication;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo, Siti',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Senang melihat Anda hari ini.',
                style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 18),

              DailyTargetCard(provider: medicationProvider),

              const SizedBox(height: 36),

              if (current != null)
                NextMedicationCard(
                  medication: current,
                  onTaken: () {
                    medicationProvider.markAsTaken(current.id);
                    _showMessage('Konfirmasi konsumsi dicatat.');
                  },
                  onSnooze: () {
                    medicationProvider.snooze(current.id);
                    _showMessage(
                      'Pengingat ditunda. Simulasi ini belum menjalankan timer.',
                    );
                  },
                )
              else
                const AllCompletedCard(),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Obat Hari Ini',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showMessage(
                      'Halaman semua jadwal akan dibuat berikutnya.',
                    ),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...medicationProvider.schedules.map(
                (medication) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MedicationListItem(medication: medication),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
