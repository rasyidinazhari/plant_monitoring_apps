import 'dart:io';
import 'package:flutter/material.dart';

class ViewResultPage extends StatelessWidget {
  final File image;
  final String name;
  final String type;
  final String diagnosis;
  final String recommendation;
  final VoidCallback onDelete;

  const ViewResultPage({
    super.key,
    required this.image,
    required this.name,
    required this.type,
    required this.diagnosis,
    required this.recommendation,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Record",
          style: TextStyle(
            fontFamily: "PoppinsBold",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView( // ← Scroll agar konten panjang tetap bisa ditampilkan
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(image, width: double.infinity),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Diagnosis AI (judul kondisi tanaman)
            Text(
              diagnosis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 8),

            // Rekomendasi AI
            Text(
              recommendation,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                onDelete(); // Hapus record
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              icon: const Icon(Icons.delete),
              label: const Text(
                "Delete Record",
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
