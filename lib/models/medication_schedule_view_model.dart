enum MedicationStatus { completed, current, upcoming, snoozed }

class MedicationScheduleViewModel {
  final String scheduleId;
  final String medicationId;

  final String name;
  final String dosage;
  final int stock;
  final String instruction;

  final String time;
  final String frequency;
  final int? weekday;

  final DateTime startDate;
  final DateTime? endDate;

  final MedicationStatus status;

  const MedicationScheduleViewModel({
    required this.scheduleId,
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.stock,
    required this.instruction,
    required this.time,
    required this.frequency,
    this.weekday,
    required this.startDate,
    this.endDate,
    required this.status,
  });
}
