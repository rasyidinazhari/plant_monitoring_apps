import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantsentry/models/gpt_vision_service.dart';
import 'package:plantsentry/services/api_service.dart';
import 'package:plantsentry/views/saverecord.dart';

class ResultView extends StatefulWidget {
  final File image;

  const ResultView({super.key, required this.image});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  String diagnosis = "Analyzing...";
  String recommendation = "AI is processing the image...";

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

Future<void> _analyzeImage() async {
  try {
    final result = await GPTVisionService.analyzeImage(widget.image);
    setState(() {
      diagnosis = result['diagnosis']!;
      recommendation = result['recommendation']!;
    });
  } catch (e) {
    setState(() {
      diagnosis = "Failed to analyze image.";
      recommendation = "Please check your connection or try again.";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Result",
          style: TextStyle(
            fontFamily: "PoppinsBold",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(widget.image, width: double.infinity),
            ),
            const SizedBox(height: 32),
            Text(
              diagnosis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              recommendation,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaveRecordView(
                      image: widget.image,
                      diagnosis: diagnosis,
                      recommendation: recommendation,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF8DAC60),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save Record",
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
