class MedicationStockModel {
  final String id;
  final String medicationId;
  final int quantity;
  final String type;
  final String? description;
  final DateTime createdAt;

  const MedicationStockModel({
    required this.id,
    required this.medicationId,
    required this.quantity,
    required this.type,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medication_id': medicationId,
      'quantity': quantity,
      'type': type,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MedicationStockModel.fromMap(Map<String, dynamic> map) {
    return MedicationStockModel(
      id: map['id'] as String,
      medicationId: map['medication_id'] as String,
      quantity: map['quantity'] as int,
      type: map['type'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
