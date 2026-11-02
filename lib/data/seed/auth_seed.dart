import '../../models/user_model.dart';

class AuthSeed {
  AuthSeed._();

  static const List<UserModel> users = [
    UserModel(
      id: 'patient-001',
      name: 'Demo Patient',
      email: 'patient@doseup.demo',
      phone: '081234567801',
      password: 'DoseUp123!',
      role: UserRole.patient,
    ),
    UserModel(
      id: 'guardian-001',
      name: 'Demo Guardian',
      email: 'guardian@doseup.demo',
      phone: '081234567802',
      password: 'DoseUp123!',
      role: UserRole.guardian,
    ),
  ];
}
