import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDataProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? getCurrentEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<String?> updateSensitiveData({
    required String currentPassword,
    String? newEmail,
    String? newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User tidak ditemukan";

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      if (newEmail != null && newEmail.isNotEmpty && newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'email': newEmail});
      }

      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (e.code == 'wrong-password') {
        return "Password saat ini salah.";
      } else if (e.code == 'email-already-in-use') {
        return "Email baru sudah digunakan akun lain.";
      } else if (e.code == 'weak-password') {
        return "Password baru terlalu lemah.";
      }
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Terjadi kesalahan: $e";
    }
  }
}