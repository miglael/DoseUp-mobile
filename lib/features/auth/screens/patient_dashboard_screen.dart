import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/medication_schedule_model.dart';
import '../providers/medication_provider.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  int _selectedTab = 0;

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

              _buildDailyTarget(medicationProvider),

              const SizedBox(height: 36),

              if (current != null)
                _buildNextMedication(current, medicationProvider)
              else
                _buildAllCompleted(),

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
                  child: _buildMedicationItem(medication),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD7E0DE)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _buildNavItem(0, Icons.home, 'Beranda'),
                _buildNavItem(1, Icons.medication_outlined, 'Jadwal'),
                _buildNavItem(2, Icons.history, 'Riwayat'),
                _buildNavItem(3, Icons.person_outline, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyTarget(MedicationProvider provider) {
    // Angka 4/5 mengikuti desain demo.
    // Aktivitas target bukan hanya jumlah obat yang selesai.
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

  Widget _buildNextMedication(
    MedicationScheduleModel medication,
    MedicationProvider provider,
  ) {
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
              onPressed: () {
                provider.markAsTaken(medication.id);
                _showMessage('Konfirmasi konsumsi dicatat.');
              },
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
              onPressed: isSnoozed
                  ? null
                  : () {
                      provider.snooze(medication.id);
                      _showMessage(
                        'Pengingat ditunda. Simulasi ini belum menjalankan timer.',
                      );
                    },
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

  Widget _buildAllCompleted() {
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

  Widget _buildMedicationItem(MedicationScheduleModel medication) {
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

  Widget _buildNavItem(int index, IconData icon, String label) {
    final selected = _selectedTab == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          setState(() => _selectedTab = index);

          if (index != 0) {
            _showMessage('Halaman $label akan dibuat pada tahap berikutnya.');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDCEAE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.textSecondary, size: 25),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
