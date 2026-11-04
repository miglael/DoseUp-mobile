import 'package:flutter/foundation.dart';

import '../../../data/seed/medication_seed.dart';
import '../../../models/medication_schedule_model.dart';

class MedicationProvider extends ChangeNotifier {
  final List<MedicationScheduleModel> _schedules =
      MedicationSeed.createSchedules();

  int _snoozeCount = 0;

  List<MedicationScheduleModel> get schedules => List.unmodifiable(_schedules);

  int get completedCount => _schedules
      .where((item) => item.status == MedicationStatus.completed)
      .length;

  int get totalCount => _schedules.length + 2;

  double get completionRate =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  int get snoozeCount => _snoozeCount;

  MedicationScheduleModel? get currentMedication {
    for (final item in _schedules) {
      if (item.status == MedicationStatus.current ||
          item.status == MedicationStatus.snoozed) {
        return item;
      }
    }
    return null;
  }

  void addMedication({
    required String name,
    required String dosage,
    required int stock,
    required String time,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    required String instruction,
  }) {
    // Halaman Jadwal saat ini menyediakan pilihan Senin-Jumat.
    // Untuk frekuensi harian, buat jadwal pada kelima hari tersebut.
    final weekdays = frequency == 'Harian'
        ? [1, 2, 3, 4, 5]
        : [startDate.weekday];

    for (final weekday in weekdays) {
      _schedules.add(
        MedicationScheduleModel(
          id: 'med-${DateTime.now().microsecondsSinceEpoch}-$weekday',
          name: name,
          dosage: dosage,
          stock: stock,
          time: time,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          instruction: instruction,
          weekday: weekday,
          status: MedicationStatus.upcoming,
        ),
      );
    }

    notifyListeners();
  }

  void markAsTaken(String id) {
    final index = _schedules.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final item = _schedules[index];

    if (item.status == MedicationStatus.completed) return;

    item.status = MedicationStatus.completed;
    _snoozeCount = 0;

    final nextIndex = _schedules.indexWhere(
      (schedule) => schedule.status == MedicationStatus.upcoming,
    );

    if (nextIndex != -1) {
      _schedules[nextIndex].status = MedicationStatus.current;
    }

    notifyListeners();
  }

  void snooze(String id) {
    final index = _schedules.indexWhere((item) => item.id == id);
    if (index == -1) return;

    if (_schedules[index].status != MedicationStatus.current &&
        _schedules[index].status != MedicationStatus.snoozed) {
      return;
    }

    _schedules[index].status = MedicationStatus.snoozed;
    _snoozeCount++;

    notifyListeners();
  }
}
