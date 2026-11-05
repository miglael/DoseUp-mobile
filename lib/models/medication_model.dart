class MedicationModel {
  final String id;
  final String patientId;
  final String name;
  final String dosage;
  final int stock;
  final String instruction;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicationModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.dosage,
    required this.stock,
    required this.instruction,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'dosage': dosage,
      'stock': stock,
      'instruction': instruction,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      stock: map['stock'] as int,
      instruction: map['instruction'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
