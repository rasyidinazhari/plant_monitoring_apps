import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  /// Mengunggah gambar ke server AI dan mengembalikan hasil diagnosis & rekomendasi
  static Future<Map<String, dynamic>> uploadImage(File image) async {
    const String url = "https://your-backend.com/analyze"; // Ganti dengan endpoint milikmu
    final dio = Dio();

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: 'scan.jpg'),
      });

      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data; // Harus mengandung: { "diagnosis": "...", "recommendation": "..." }
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
