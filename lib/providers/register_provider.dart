import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> register(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      if (e.code == 'weak-password') {
        return 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        return 'Email sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      }
      return 'Terjadi kesalahan, coba lagi.';
    } catch (e) {
      _setLoading(false);
      return 'Terjadi kesalahan, coba lagi.';
    }
  }
}
