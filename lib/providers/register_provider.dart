import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> register(
    String username,
    String email,
    String password,
  ) async {
    _setLoading(true);
    try {
      // REGISTER USER
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = result.user!.uid;

      // SAVE TO FIRESTORE
      await _db.collection("users").doc(uid).set({
        "uid": uid,
        "username": username.trim(),
        "email": email.trim(),
        "created_at": DateTime.now(),
      });

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
