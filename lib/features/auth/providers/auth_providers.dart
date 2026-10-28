import 'package:flutter/foundation.dart';

import '../../../data/seed/auth_seed.dart';
import '../../../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _selectedRole = UserRole.patient;
  UserModel? _currentUser;
  String? _errorMessage;

  UserRole get selectedRole => _selectedRole;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  void selectRole(UserRole role) {
    _selectedRole = role;
    _errorMessage = null;
    notifyListeners();
  }

  bool login({required String identifier, required String password}) {
    _errorMessage = null;

    final normalizedIdentifier = identifier.trim().toLowerCase();

    if (normalizedIdentifier.isEmpty || password.isEmpty) {
      _errorMessage = 'Email/nomor HP dan kata sandi wajib diisi.';
      notifyListeners();
      return false;
    }

    UserModel? matchedUser;

    for (final user in AuthSeed.users) {
      final emailMatches = user.email.toLowerCase() == normalizedIdentifier;

      final phoneMatches = user.phone == identifier.trim();

      final passwordMatches = user.password == password;

      final roleMatches = user.role == _selectedRole;

      if ((emailMatches || phoneMatches) && passwordMatches && roleMatches) {
        matchedUser = user;
        break;
      }
    }

    if (matchedUser == null) {
      _errorMessage = 'Akun tidak ditemukan atau data login tidak sesuai.';
      notifyListeners();
      return false;
    }

    _currentUser = matchedUser;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    _selectedRole = UserRole.patient;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}
