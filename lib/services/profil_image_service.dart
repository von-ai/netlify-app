import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageAsBase64() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400, 
        maxHeight: 400,
        imageQuality: 50, 
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
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