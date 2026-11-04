enum MedicationStatus { completed, current, upcoming, snoozed }

class MedicationScheduleModel {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String instruction;
  final int weekday;

  final int stock;
  final String frequency;
  final DateTime? startDate;
  final DateTime? endDate;

  MedicationStatus status;

  MedicationScheduleModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.instruction,
    this.weekday = 3,
    this.stock = 0,
    this.frequency = 'Harian',
    this.startDate,
    this.endDate,
    required this.status,
  });
}
