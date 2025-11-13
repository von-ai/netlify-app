import 'package:flutter/material.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'register_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _Onboarding();
}

class _Onboarding extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.background],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Netlify',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Track Your Series',
              style: TextStyle(color: AppColors.textDark),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome back',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.textDark,
                border: Border.all(color: AppColors.textDark),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
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

            SizedBox(height: 10),

            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
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

            // Spacer(),
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            Text(
              'Or Log In with',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Row(
            SizedBox(height: 20),
            //   children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              padding: EdgeInsets.only(top: 12, bottom: 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.textDark,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Image.asset(
                'assets/icons/google.png',
                width: 25,
                height: 25,
                // fit: BoxFit.cover,
              ),
            ),
            // ],
            // ),
          ],
        ),
      ),
    );
  }
}
