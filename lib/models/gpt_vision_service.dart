import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GPTVisionService {
  static const _apiKey = "YOUR-API-KEY"; // GANTI dengan API key kamu
  static const _endpoint = "https://api.openai.com/v1/chat/completions";

  static Future<Map<String, String>> analyzeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "Apa diagnosis tanaman ini dan berikan rekomendasi perawatan singkat. Jawab dengan format:\nDiagnosis: ...\nRekomendasi: ...",
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
                },
              ],
            },
          ],
          "max_tokens": 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data["choices"][0]["message"]["content"] as String;

        // Debug output untuk isi response jika perlu
        print("✅ GPT Response Content:\n$content");

        // Pisahkan diagnosis dan rekomendasi berdasarkan format
        final lines = content.split('\n');
        String diagnosis = '';
        String recommendation = '';

        for (var line in lines) {
          if (line.toLowerCase().startsWith('diagnosis')) {
            diagnosis = line.split(':').sublist(1).join(':').trim();
          } else if (line.toLowerCase().startsWith('rekomendasi') ||
              line.toLowerCase().startsWith('recommendation')) {
            recommendation = line.split(':').sublist(1).join(':').trim();
          }
        }

        return {
          "diagnosis": diagnosis.isNotEmpty ? diagnosis : "No diagnosis found.",
          "recommendation":
              recommendation.isNotEmpty
                  ? recommendation
                  : "No recommendation found.",
        };
      } else {
        // Tambahkan ini agar bisa dicek error dari backend
        print("❌ GPT API ERROR: ${response.statusCode}");
        print("❌ GPT API RESPONSE: ${response.body}");
        throw Exception("Failed to analyze image: ${response.body}");
      }
    } catch (e, stacktrace) {
      print("❌ Exception during analyzeImage: $e");
      print("🔍 Stacktrace: $stacktrace");
      return {
        "diagnosis": "Failed to analyze image.",
        "recommendation": "Please check your connection or try again.",
      };
    }
  }
}
