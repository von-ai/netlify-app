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
  
  String? _base64Image;
  String? _currentPhotoData;

  bool _isLoading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
            _currentPhotoData = data['photoUrl'];
          });
        }
      } catch (e) {
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
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
      String? finalPhotoData;
      if (_base64Image != null) {
        finalPhotoData = _base64Image;
      } 
      else if (_currentPhotoData != null) {
        finalPhotoData = _currentPhotoData;
      } 
      else {
        finalPhotoData = null;
      }

      Map<String, dynamic> updateData = {
        'username': _usernameController.text.trim(),
        'photoUrl': finalPhotoData,
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
      _base64Image = null;
      _currentPhotoData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(child: _profilePictureSection()),
              const SizedBox(height: 24),
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

  Widget _profilePictureSection() {
    ImageProvider? imageProvider;

    if (_base64Image != null) {
      imageProvider = MemoryImage(base64Decode(_base64Image!));
    } else if (_currentPhotoData != null && _currentPhotoData!.isNotEmpty) {
      try {
        imageProvider = MemoryImage(base64Decode(_currentPhotoData!));
      } catch (e) {
        imageProvider = NetworkImage(_currentPhotoData!);
      }
    }
    bool hasPhoto = imageProvider != null;

    return Center(
      child: Stack(
        children: [
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

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
              ),
            ),
          ),

          if (hasPhoto)
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: _removePhoto, 
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
          style: t.bodyLarge?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(i, color: AppColors.primary),
            filled: true, 
            fillColor: const Color(0xFF1E1E1E),
            labelText: l, 
            labelStyle: t.bodyMedium?.copyWith(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (v) => v!.isEmpty ? "$l required" : null,
        );
  }

  Widget _submitButton(TextTheme t) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
      onPressed: _isLoading ? null : _saveProfile,
      child: Text(
        "Simpan", 
        style: t.bodyLarge?.copyWith(
          color: Colors.black, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}