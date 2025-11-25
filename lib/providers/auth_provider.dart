import 'package:flutter/foundation.dart';
import 'package:project_mobile/services/auth_service.dart';

class SigninProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // bool get isLoggedIn => _authService.getCurrentUser() != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    final result = await _authService.signIn(email, password);
    _setLoading(false);
    return result;
  }
}
