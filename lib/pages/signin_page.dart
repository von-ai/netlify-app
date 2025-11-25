import 'package:flutter/material.dart';
import 'package:project_mobile/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/providers/signin_provider.dart';
import 'package:project_mobile/widgets/card_container.dart';
import 'package:project_mobile/widgets/navbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // final provider = context.read<SigninProvider>();
      // // if (provider.isLoggedIn) {
      // //   Navigator.pushReplacement(
      // //     context,
      // //     MaterialPageRoute(builder: (_) => NavBar()),
      // //   );
      // // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SigninProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: CardContainer(
            children: [
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _form(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(SigninProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputField(
            controller: _emailController,
            label: "Email",
            icon: Icons.email_outlined,
            validator: (v) {
              if (v!.isEmpty) return "Email tidak boleh kosong";
              return null;
            },
          ),
          const SizedBox(height: 18),
          InputField(
            controller: _passwordController,
            label: "Password",
            icon: Icons.lock_outline,
            obscure: !_isPasswordVisible,
            suffix: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primary,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          const SizedBox(height: 32),
          provider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _login(provider),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Sign In"),
                ),
        ],
      ),
    );
  }

  Future<void> _login(SigninProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final message = await provider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (message == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NavBar()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
