// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/pages/onboarding.dart';

class Logout{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk Logout
  Future<void> signOut(BuildContext context) async {
    try {
      // 1. Proses Logout dari Firebase
      await _auth.signOut();

      // 2. Cek apakah widget masih aktif sebelum navigasi
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
          (route) => false,
        );
      }
    } catch (e) {
      // Tampilkan error jika gagal logout (opsional)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal Logout: $e")),
        );
      }
    }
  }
}