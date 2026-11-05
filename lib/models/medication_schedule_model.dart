class MedicationScheduleModel {
  final String id;
  final String medicationId;
  final String frequency;
  final String time;
  final int? weekday;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  const MedicationScheduleModel({
    required this.id,
    required this.medicationId,
    required this.frequency,
    required this.time,
    this.weekday,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medication_id': medicationId,
      'frequency': frequency,
      'time': time,
      'weekday': weekday,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory MedicationScheduleModel.fromMap(Map<String, dynamic> map) {
    return MedicationScheduleModel(
      id: map['id'] as String,
      medicationId: map['medication_id'] as String,
      frequency: map['frequency'] as String,
      time: map['time'] as String,
      weekday: map['weekday'] as int?,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] == null
          ? null
          : DateTime.parse(map['end_date'] as String),
      isActive: map['is_active'] == 1,
    );
  }
}
