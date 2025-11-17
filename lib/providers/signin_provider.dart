import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _setLoading(false);
      return null;
      
    } on FirebaseAuthException catch (e) {
      _setLoading(false);

      if (e.code == 'user-not-found' || 
          e.code == 'wrong-password' || 
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'Email atau password salah.';
      } 
      else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } 
      else {
        return 'Error: ${e.code}'; 
      }
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }
}