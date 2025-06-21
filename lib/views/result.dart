import 'dart:io';
import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final File image;

  const ResultView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(image, width: double.infinity),
            ),
            const SizedBox(height: 32),
            const Text(
              "Good Condition",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Recommendation:\n\n"
              "- Use fertile, loose, well-drained soil.\n"
              "- For pots: a mixture of soil, compost, and sand can be an ideal combination.",
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Record saved! (simulasi)")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Save Record", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
