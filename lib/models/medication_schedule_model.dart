enum MedicationStatus { completed, current, upcoming, snoozed }

class MedicationScheduleModel {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String instruction;
  final int weekday;

  MedicationStatus status;

  MedicationScheduleModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.instruction,
    this.weekday = 3,
    required this.status,
  });
}
