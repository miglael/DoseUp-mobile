class GuardianModel {
  final String id;
  final String patientId;
  final String name;
  final String? email;
  final String? phone;
  final String? relationship;
  final DateTime createdAt;

  const GuardianModel({
    required this.id,
    required this.patientId,
    required this.name,
    this.email,
    this.phone,
    this.relationship,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'email': email,
      'phone': phone,
      'relationship': relationship,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory GuardianModel.fromMap(Map<String, dynamic> map) {
    return GuardianModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      relationship: map['relationship'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
