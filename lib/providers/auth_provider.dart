import 'package:flutter/material.dart';
import 'package:project_mobile/models/user_model.dart';
import 'package:project_mobile/services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final user = UserModel(email: email, password: password);
    final success = await _authService.login(user);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
