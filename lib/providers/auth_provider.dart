import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/enums/user_role.dart';
import 'app_data_provider.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isSuperAdmin => _currentUser?.role == UserRole.superAdmin;
  bool get isAdmin =>
      _currentUser?.role == UserRole.admin ||
      _currentUser?.role == UserRole.superAdmin;
  bool get isMember => _currentUser?.role == UserRole.member;
  bool get isVolunteer => _currentUser?.role == UserRole.volunteer;

  Future<bool> login(String email, String password, AppDataProvider dataProvider) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = dataProvider.users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      // Mock password validation (in production, use secure auth)
      if (password.length < 6) {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void updateCurrentUser(UserModel updatedUser) {
    if (_currentUser?.id == updatedUser.id) {
      _currentUser = updatedUser;
      notifyListeners();
    }
  }
}
