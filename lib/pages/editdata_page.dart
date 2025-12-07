import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/providers/editdata_provider.dart';

class EditDataPage extends StatefulWidget {
  const EditDataPage({super.key});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPassController = TextEditingController();
  final _currentPassController = TextEditingController();
  bool _obscureNewPass = true;
  bool _obscureCurrentPass = true;

  @override
  void initState() {
    super.initState();
    final currentEmail = context.read<EditDataProvider>().getCurrentEmail();
    if (currentEmail != null) {
      _emailController.text = currentEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPassController.dispose();
    _currentPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keamanan Akun",
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: Consumer<EditDataProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ubah Email & Password",
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Isi hanya data yang ingin diubah. Password saat ini wajib diisi untuk konfirmasi.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _inputLabel("Email Baru"),
                  TextFormField(
                    controller: _emailController,
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    decoration: _inputDecor(Icons.email),
                  ),
                  const SizedBox(height: 24),
                  _inputLabel("Password Baru (Opsional)"),
                  TextFormField(
                    controller: _newPassController,
                    obscureText: _obscureNewPass,
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    decoration: _inputDecor(Icons.lock_outline).copyWith(
                      hintText: "Kosongkan jika tidak ingin ubah",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPass = !_obscureNewPass;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const Divider(height: 48, color: Colors.grey),
                  _inputLabel("Password Saat Ini (Wajib)"),
                  TextFormField(
                    controller: _currentPassController,
                    obscureText: _obscureCurrentPass,
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    decoration: _inputDecor(Icons.lock).copyWith(
                      hintText: "Masukkan password untuk simpan",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPass = !_obscureNewPass;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib isi password saat ini untuk keamanan";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final error =
                                    await provider.updateSensitiveData(
                                  currentPassword: _currentPassController.text,
                                  newEmail: _emailController.text.trim(),
                                  newPassword: _newPassController.text.trim(),
                                );

                                if (!context.mounted) return;

                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Data akun berhasil diperbarui! Silakan login ulang jika diperlukan.")),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Gagal: $error")),
                                  );
                                }
                              }
                            },
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              "Simpan Perubahan",
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  InputDecoration _inputDecor(IconData icon) {
    final textTheme = Theme.of(context).textTheme;
    
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white24),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: Colors.redAccent),
    );
  }
}