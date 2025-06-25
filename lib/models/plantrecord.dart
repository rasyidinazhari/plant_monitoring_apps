import 'dart:convert';

class PlantRecord {
  final String imagePath;
  final String name;
  final String type;
  final String diagnosis;
  final String recommendation;

  PlantRecord({
    required this.imagePath,
    required this.name,
    required this.type,
    this.diagnosis = '',
    this.recommendation = '',
  });

  // Konversi ke Map (untuk disimpan atau diubah ke JSON)
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'type': type,
      'diagnosis': diagnosis,
      'recommendation': recommendation,
    };
  }

  // Buat objek PlantRecord dari Map
  factory PlantRecord.fromMap(Map<String, dynamic> map) {
    return PlantRecord(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      recommendation: map['recommendation'] ?? '',
    );
  }

  // Ubah PlantRecord ke JSON String
  String toJson() => jsonEncode(toMap());

  // Buat objek PlantRecord dari JSON String atau Map (fleksibel)
  factory PlantRecord.fromJson(dynamic source) {
    if (source is String) {
      return PlantRecord.fromMap(jsonDecode(source));
    } else if (source is Map<String, dynamic>) {
      return PlantRecord.fromMap(source);
    } else {
      throw FormatException("Invalid source type for PlantRecord.fromJson");
    }
  }
}
