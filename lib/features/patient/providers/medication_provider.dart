import 'package:flutter/foundation.dart';

import '../../../data/repositories/medication_repository.dart';
import '../../../models/medication_schedule_view_model.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationRepository _repository;

  MedicationProvider({MedicationRepository? repository})
    : _repository = repository ?? MedicationRepository() {
    loadTodaySchedules();
  }

  List<MedicationScheduleViewModel> _schedules = [];

  bool _isLoading = false;
  String? _errorMessage;

  DateTime _selectedDate = DateTime.now();

  // ============================================================
  // GETTERS
  // ============================================================

  List<MedicationScheduleViewModel> get schedules =>
      List.unmodifiable(_schedules);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get completedCount => _schedules
      .where((item) => item.status == MedicationStatus.completed)
      .length;

  int get totalCount => _schedules.length;

  double get completionRate =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  int get snoozeCount => _schedules
      .where((item) => item.status == MedicationStatus.snoozed)
      .length;

  DateTime get selectedDate => _selectedDate;

  MedicationScheduleViewModel? get currentMedication {
    for (final item in _schedules) {
      if (item.status == MedicationStatus.current ||
          item.status == MedicationStatus.snoozed) {
        return item;
      }
    }

    return null;
  }

  // ============================================================
  // LOAD SCHEDULES
  // ============================================================

  Future<void> loadTodaySchedules() async {
    await loadSchedulesForDate(DateTime.now());
  }

  Future<void> loadSchedulesForDate(DateTime date) async {
    _selectedDate = DateTime(date.year, date.month, date.day);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await _repository.getSchedulesForDate(_selectedDate);
    } catch (error) {
      _errorMessage = 'Gagal memuat jadwal obat: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // ADD MEDICATION
  // ============================================================

  Future<void> addMedication({
    required String name,
    required String dosage,
    required int stock,
    required String time,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    required String instruction,
    List<int> selectedWeekdays = const [],
  }) async {
    await _repository.addMedication(
      name: name,
      dosage: dosage,
      stock: stock,
      time: time,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
      instruction: instruction,
      selectedWeekdays: selectedWeekdays,
    );

    await loadSchedulesForDate(_selectedDate);
  }

  // ============================================================
  // MARK AS TAKEN
  // ============================================================

  Future<void> markAsTaken(String scheduleId) async {
    try {
      await _repository.markAsTaken(
        scheduleId: scheduleId,
        date: _selectedDate,
      );

      await loadSchedulesForDate(_selectedDate);
    } catch (error) {
      _errorMessage = 'Gagal menyimpan konsumsi obat: $error';
      notifyListeners();
    }
  }

  // ============================================================
  // SNOOZE
  // ============================================================

  Future<void> snooze(
    String scheduleId, {
    Duration duration = const Duration(minutes: 10),
  }) async {
    try {
      await _repository.snooze(
        scheduleId: scheduleId,
        date: _selectedDate,
        duration: duration,
      );

      await loadSchedulesForDate(_selectedDate);
    } catch (error) {
      _errorMessage = 'Gagal menunda pengingat obat: $error';
      notifyListeners();
    }
  }
}
