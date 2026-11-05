class HealthLogModel {
  final String id;
  final String patientId;
  final String? bloodPressure;
  final double? bloodSugar;
  final double? weight;
  final String? notes;
  final DateTime recordedAt;

  const HealthLogModel({
    required this.id,
    required this.patientId,
    this.bloodPressure,
    this.bloodSugar,
    this.weight,
    this.notes,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'blood_pressure': bloodPressure,
      'blood_sugar': bloodSugar,
      'weight': weight,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory HealthLogModel.fromMap(Map<String, dynamic> map) {
    return HealthLogModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      bloodPressure: map['blood_pressure'] as String?,
      bloodSugar: (map['blood_sugar'] as num?)?.toDouble(),
      weight: (map['weight'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }
}
