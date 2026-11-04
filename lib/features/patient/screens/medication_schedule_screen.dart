import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_bottom_navbar.dart';
import '../../../models/medication_schedule_model.dart';
import '../providers/medication_provider.dart';
import '../widgets/day_selector.dart';
import '../widgets/schedule_medication_card.dart';

class MedicationScheduleScreen extends StatefulWidget {
  const MedicationScheduleScreen({super.key});

  @override
  State<MedicationScheduleScreen> createState() =>
      _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  int _selectedDay = 3;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicationProvider>();

    final dailySchedules = provider.schedules
        .where((item) => item.weekday == _selectedDay)
        .toList();

    final morningSchedules = dailySchedules.where((item) {
      final hour = int.tryParse(item.time.split(':').first) ?? 0;
      return hour < 12;
    }).toList();

    final nightSchedules = dailySchedules.where((item) {
      final hour = int.tryParse(item.time.split(':').first) ?? 0;
      return hour >= 12;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FE),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DaySelector(
                      selectedDay: _selectedDay,
                      onChanged: (day) {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                    ),

                    const SizedBox(height: 40),

                    if (dailySchedules.isEmpty)
                      _buildEmptySchedule()
                    else ...[
                      if (morningSchedules.isNotEmpty) ...[
                        _buildSectionTitle('Pagi'),
                        const SizedBox(height: 18),
                        ...morningSchedules.map(
                          (medication) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ScheduleMedicationCard(
                              medication: medication,
                              onToggle: () =>
                                  _toggleMedication(provider, medication),
                            ),
                          ),
                        ),
                      ],

                      if (nightSchedules.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _buildSectionTitle('Malam'),
                        const SizedBox(height: 18),
                        ...nightSchedules.map(
                          (medication) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ScheduleMedicationCard(
                              medication: medication,
                              onToggle: () =>
                                  _toggleMedication(provider, medication),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMessage('Fitur tambah jadwal obat akan dibuat berikutnya.');
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8FE),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFDCEAE7),
            child: Icon(Icons.person, color: AppTheme.primary, size: 32),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Text(
              'Jadwal Obat',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              _showMessage('Notifikasi akan dibuat pada tahap berikutnya.');
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppTheme.primary,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada jadwal obat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Jadwal obat untuk hari ini belum tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMedication(
    MedicationProvider provider,
    MedicationScheduleModel medication,
  ) {
    if (medication.status == MedicationStatus.completed) {
      _showMessage('Obat ini sudah ditandai selesai.');
      return;
    }

    provider.markAsTaken(medication.id);
    _showMessage('Status ${medication.name} berhasil diperbarui.');
  }
}
