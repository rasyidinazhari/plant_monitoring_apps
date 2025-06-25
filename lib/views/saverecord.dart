import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantsentry/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantsentry/models/plantrecord.dart';

class SaveRecordView extends StatefulWidget {
  final File image;
  final String diagnosis;
  final String recommendation;

  const SaveRecordView({
    super.key,
    required this.image,
    required this.diagnosis,
    required this.recommendation,
  });

  @override
  State<SaveRecordView> createState() => _SaveRecordViewState();
}

class _SaveRecordViewState extends State<SaveRecordView> {
  final TextEditingController nameController = TextEditingController();
  String? selectedType;

  final List<String> typeOptions = ['Sayur', 'Tanaman', 'Buah'];

  Future<void> saveRecord() async {
    if (selectedType == null || nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan jenis harus diisi")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final newRecord = PlantRecord(
      name: nameController.text.trim(),
      type: selectedType!,
      imagePath: widget.image.path,
      diagnosis: widget.diagnosis,
      recommendation: widget.recommendation,
    );

    List<String> records = prefs.getStringList('records') ?? [];
    records.add(newRecord.toJson()); // Tidak perlu jsonEncode lagi
    await prefs.setStringList('records', records);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePageView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Simpan Hasil",
          style: TextStyle(
            fontFamily: "PoppinsBold",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Nama", style: TextStyle(fontFamily: "PoppinsBold")),
            const SizedBox(height: 8),
            TextField(controller: nameController),

            const SizedBox(height: 16),
            const Text("Jenis", style: TextStyle(fontFamily: "PoppinsBold")),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Pilih jenis",
              ),
              items: typeOptions.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF8DAC60),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  