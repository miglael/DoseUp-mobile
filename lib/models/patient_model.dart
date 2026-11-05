class PatientModel {
  final String id;
  final String name;
  final int? age;
  final String? email;
  final String? phone;
  final DateTime createdAt;

  const PatientModel({
    required this.id,
    required this.name,
    this.age,
    this.email,
    this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
