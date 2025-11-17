import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/pages/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:project_mobile/widgets/navbar.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Terjadi kesalahan pada autentikasi.")),
          );
        }

        if (snapshot.hasData) {
          return ChangeNotifierProvider(create: (_) => NavBarProvider());
        } else {
          return Onboarding();
        }
      },
    );
  }
}