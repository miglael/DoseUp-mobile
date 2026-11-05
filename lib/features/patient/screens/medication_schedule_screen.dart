import 'package:doseup_project/features/patient/screens/add_medication.dart';
import 'package:doseup_project/models/medication_schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
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
  late DateTime _selectedDate;

  DateTime _getDateForWeekday(int weekday) {
    final today = DateTime.now();

    // Cari hari Senin pada minggu berjalan.
    final monday = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: today.weekday - 1));

    return monday.add(Duration(days: weekday - 1));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationProvider>().loadSchedulesForDate(_selectedDate);
    });
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    setState(() {
      _selectedDate = selectedDate;
    });

    await context.read<MedicationProvider>().loadSchedulesForDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicationProvider>();

    final dailySchedules = provider.schedules;

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
                      selectedDate: _selectedDate,
                      onChanged: (date) async {
                        setState(() {
                          _selectedDate = date;
                        });

                        await context
                            .read<MedicationProvider>()
                            .loadSchedulesForDate(date);
                      },
                    ),

                    const SizedBox(height: 12),

                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_selectedDate.day} '
                              '${_monthName(_selectedDate.month)} '
                              '${_selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
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
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
          );

          if (!context.mounted) return;

          if (result == true) {
            _showMessage('Obat berhasil ditambahkan.');
          }
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

  Future<void> _toggleMedication(
    MedicationProvider provider,
    MedicationScheduleViewModel medication,
  ) async {
    if (medication.status == MedicationStatus.completed) {
      return;
    }

    await provider.markAsTaken(medication.scheduleId);

    if (!mounted) return;

    _showMessage('Status ${medication.name} berhasil diperbarui.');
  }
}
