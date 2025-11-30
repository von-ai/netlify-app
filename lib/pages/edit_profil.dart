import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/core/theme/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (currentUser != null) {
      setState(() => _isLoading = true);
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _usernameController.text = data['username'] ?? '';
            _emailController.text = data['email'] ?? currentUser!.email ?? '';
          });
        }
      } catch (e) {
        // Handle error quietly
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'username': _usernameController.text.trim()});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil TextTheme dari main.dart agar font konsisten
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: _profilePictureSection()),
                const SizedBox(height: 24),
                
                // DISINI PEMBUNGKUS CARD (Kotak Abu-abu)
                _cardContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _field(
                          _usernameController,
                          "Username",
                          Icons.person_outline,
                          textTheme,
                        ),
                        const SizedBox(height: 16),
                        _field(
                          _emailController,
                          "Email",
                          Icons.email_outlined,
                          textTheme,
                          isReadOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                _submitButton(textTheme),
              ],
            ),
    );
  }

 Widget _profilePictureSection() {
    return Stack(
      children: [
        // Container Abu-abu (Sama persis dengan halaman Profile)
        Container(
          width: 120, // Ukuran disamakan (sebelumnya 100)
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[800], // Warna abu-abu yang sama
            shape: BoxShape.circle,
            // Border hijau dihapus agar konsisten
          ),
          child: const Icon(
            Icons.person,
            size: 80, // Ukuran ikon diperbesar agar proporsional
            color: Colors.white,
          ),
        ),
        
        // Ikon Kamera Kecil di Pojok Bawah
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 35, // Ukuran disamakan dengan tombol edit di profil
            height: 35,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt, // Tetap icon kamera untuk fitur ganti foto
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
  
  // WIDGET CARD: Kotak Abu-abu di belakang form
  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Warna abu-abu gelap
        borderRadius: BorderRadius.circular(18), // Sudut tumpul
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    TextTheme textTheme, {
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas input (Opsional, tapi membantu kerapian)
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          style: textTheme.bodyLarge?.copyWith(
            color: isReadOnly ? Colors.grey.shade500 : Colors.white,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: const Color(0xFF1E1E1E), // Warna dalam input
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), // Sudut tumpul input
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade900),
            ),
          ),
          validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null,
        ),
      ],
    );
  }

  Widget _submitButton(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        onPressed: _isLoading ? null : _saveProfile,
        child: Text(
          "Simpan Perubahan",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}