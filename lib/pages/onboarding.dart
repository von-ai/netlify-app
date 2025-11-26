import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/pages/register_page.dart';
import 'package:project_mobile/pages/signin_page.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Netlify',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track Your Series',
                style: TextStyle(color: AppColors.textDark, fontSize: 16),
              ),

              const SizedBox(height: 28),
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.textDark,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.12),
            ],
          ),
        ),
      ),
    );
  }
}
