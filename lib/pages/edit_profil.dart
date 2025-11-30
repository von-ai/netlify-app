import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/core/theme/colors.dart';
import 'package:project_mobile/services/profil_image_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final ImageService _imageService = ImageService();
  
  String? _base64Image; // Menyimpan string gambar baru
  String? _currentPhotoData; // Menyimpan string gambar lama dari DB

  bool _isLoading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ... dispose ...

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
            _currentPhotoData = data['photoUrl']; // Ini isinya text panjang
          });
        }
      } catch (e) {
        // handle error
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // AMBIL GAMBAR JADI BASE64
  Future<void> _pickImage() async {
    // Panggil service yang baru
    String? base64Result = await _imageService.pickImageAsBase64();
    
    if (base64Result != null) {
      setState(() {
        _base64Image = base64Result;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // Tentukan data foto apa yang mau disimpan
      String? finalPhotoData;

      if (_base64Image != null) {
        // Kasus 1: User pilih foto baru
        finalPhotoData = _base64Image;
      } else if (_currentPhotoData != null) {
        // Kasus 2: User tidak ngapa-ngapain (tetap pakai foto lama)
        finalPhotoData = _currentPhotoData;
      } else {
        // Kasus 3: User menghapus foto (keduanya null)
        finalPhotoData = null;
      }

      Map<String, dynamic> updateData = {
        'username': _usernameController.text.trim(),
        'photoUrl': finalPhotoData, // Bisa berisi string foto, atau null (terhapus)
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removePhoto() {
    setState(() {
      _base64Image = null;       // Hapus foto yang baru dipilih (jika ada)
      _currentPhotoData = null;  // Hapus foto lama dari tampilan
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... Bagian Scaffold UI SAMA SAJA ...
    // ... Langsung ke logic tampilan foto ...
    
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile"), // pendekin biar cepat
        centerTitle: true,
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(child: _profilePictureSection()),
              const SizedBox(height: 24),
              // ... Form username email sama saja ...
               _cardContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _field(_usernameController, "Username", Icons.person_outline, textTheme),
                        const SizedBox(height: 16),
                        _field(_emailController, "Email", Icons.email_outlined, textTheme, isReadOnly: true),
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

  // WIDGET FOTO (LOGIC BASE64)
  Widget _profilePictureSection() {
    ImageProvider? imageProvider;

    // Logic Preview
    if (_base64Image != null) {
      imageProvider = MemoryImage(base64Decode(_base64Image!));
    } else if (_currentPhotoData != null && _currentPhotoData!.isNotEmpty) {
      try {
        imageProvider = MemoryImage(base64Decode(_currentPhotoData!));
      } catch (e) {
        imageProvider = NetworkImage(_currentPhotoData!);
      }
    }

    // Cek apakah sedang ada foto (untuk menentukan tombol hapus muncul/tidak)
    bool hasPhoto = imageProvider != null;

    return Center(
      child: Stack(
        children: [
          // 1. Lingkaran Foto
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
              image: hasPhoto
                  ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  : null,
            ),
            child: !hasPhoto
                ? const Icon(Icons.person, size: 80, color: Colors.white)
                : null,
          ),

          // 2. Tombol Kamera (Kanan Bawah)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: AppColors.primary, // Hijau
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
              ),
            ),
          ),

          // 3. Tombol Hapus / Sampah (Kiri Bawah) - HANYA MUNCUL JIKA ADA FOTO
          if (hasPhoto)
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: _removePhoto, // Panggil fungsi hapus
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red[400], // Merah
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2), // Biar ada jarak dikit
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ... (Helper Widget _cardContainer, _field, _submitButton copy dari sebelumnya) ...
  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18)),
      child: child,
    );
  }

  Widget _field(TextEditingController c, String l, IconData i, TextTheme t, {bool isReadOnly = false}) {
     return TextFormField(
          controller: c,
          readOnly: isReadOnly,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(i, color: AppColors.primary),
            filled: true, fillColor: const Color(0xFF1E1E1E),
            labelText: l, labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (v) => v!.isEmpty ? "$l required" : null,
        );
  }

  Widget _submitButton(TextTheme t) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.all(16)),
      onPressed: _isLoading ? null : _saveProfile,
      child: Text("Simpan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}