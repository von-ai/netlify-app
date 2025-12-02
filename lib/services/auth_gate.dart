import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/pages/onboarding.dart';
import 'package:project_mobile/widgets/navbar.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background, 
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const NavBar(); 
        }
        return const Onboarding(); 
      },
    );
  }
}