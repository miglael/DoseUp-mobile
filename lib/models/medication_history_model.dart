class MedicationHistoryModel {
  final String id;
  final String scheduleId;
  final DateTime scheduledAt;
  final DateTime? takenAt;
  final String status;
  final DateTime? snoozedUntil;

  const MedicationHistoryModel({
    required this.id,
    required this.scheduleId,
    required this.scheduledAt,
    this.takenAt,
    required this.status,
    this.snoozedUntil,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'taken_at': takenAt?.toIso8601String(),
      'status': status,
      'snoozed_until': snoozedUntil?.toIso8601String(),
    };
  }

  factory MedicationHistoryModel.fromMap(Map<String, dynamic> map) {
    return MedicationHistoryModel(
      id: map['id'] as String,
      scheduleId: map['schedule_id'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      takenAt: map['taken_at'] == null
          ? null
          : DateTime.parse(map['taken_at'] as String),
      status: map['status'] as String,
      snoozedUntil: map['snoozed_until'] == null
          ? null
          : DateTime.parse(map['snoozed_until'] as String),
    );
  }
}
