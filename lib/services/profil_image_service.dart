import 'dart:convert'; // Untuk base64Encode
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  // Fungsi: Ambil Gambar & Ubah jadi String Base64
  Future<String?> pickImageAsBase64() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // KOMPRESI PENTING: Agar tidak menuhin database
        maxWidth: 400, 
        maxHeight: 400,
        imageQuality: 50, 
      );
      
      if (pickedFile != null) {
        // Baca file sebagai bytes
        final bytes = await pickedFile.readAsBytes();
        // Ubah bytes menjadi String panjang (Base64)
        String base64String = base64Encode(bytes);
        return base64String;
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }
}