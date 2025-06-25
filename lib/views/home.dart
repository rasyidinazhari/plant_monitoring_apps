import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantsentry/models/plantrecord.dart';
import 'package:plantsentry/views/viewrecord.dart';
import 'package:plantsentry/views/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<PlantRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

    Future<void> _loadRecords() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> rawRecords = prefs.getStringList('records') ?? [];

  List<PlantRecord> loadedRecords = [];

  for (String recordStr in rawRecords) {
    try {
      final decoded = jsonDecode(recordStr);
      final record = PlantRecord.fromJson(decoded);

      // Opsional: hanya tampilkan jika file masih ada
      if (File(record.imagePath).existsSync()) {
        loadedRecords.add(record);
      }
    } catch (e) {
      debugPrint("Gagal parse record: $e");
    }
  }

  setState(() {
    _records = loadedRecords;
  });
}


  Future<void> _deleteRecord(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _records.removeAt(index);
    });
    List<String> updated = _records.map((r) => r.toJson()).toList();
    await prefs.setStringList('records', updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF8DAC60),
        onPressed: () => _showScanOptions(context),
        child: const Icon(Icons.local_florist_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: RefreshIndicator(
            onRefresh: _loadRecords,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 24),
                const Text("Record",
                    style: TextStyle(fontSize: 22, fontFamily: "PoppinsBold", fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                if (_records.isEmpty)
                  const Center(child: Text("Belum ada data.", style: TextStyle(fontSize: 14))),
                ..._records.asMap().entries.map((entry) {
                  int index = entry.key;
                  PlantRecord record = entry.value;

                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewResultPage(
                            image: File(record.imagePath),
                            name: record.name,
                            type: record.type,
                            diagnosis: record.diagnosis,
                            recommendation: record.recommendation,
                            onDelete: () => _deleteRecord(index),
                          ),
                        ),
                      );
                      await _loadRecords(); // reload jika baru saja dihapus
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Image.file(File(record.imagePath), width: 40, height: 40, fit: BoxFit.cover),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(record.name,
                                    style: const TextStyle(
                                        fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                                Text(record.type,
                                    style: const TextStyle(
                                        fontSize: 12, fontFamily: "Poppins", color: Colors.grey)),
                                if (record.diagnosis.isNotEmpty)
                                  Text(record.diagnosis,
                                      style: const TextStyle(fontSize: 12, color: Colors.green)),
                              ],
                            ),
                          ),
                          Icon(_getIconForType(record.type), color: Colors.green),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Hai, Bungg!", style: TextStyle(fontFamily: "Poppins", fontSize: 14)),
                Text("Good Parents!", style: TextStyle(fontFamily: "PoppinsBold", fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded, color: Colors.green),
        ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'sayur':
      case 'sayuran':
        return Icons.spa;
      case 'buah':
        return Icons.apple;
      case 'tanaman':
        return Icons.eco;
      default:
        return Icons.local_florist;
    }
  }

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Scan with", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "PoppinsBold")),
              const SizedBox(height: 16),
              _scanOption(
                assetPath: 'assets/images/drone-camera.png',
                label: "Drone",
                color: Colors.blue.shade100,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  // Tambahkan fungsi drone
                },
              ),
              const SizedBox(height: 12),
              _scanOption(
                assetPath: 'assets/images/camera.png',
                label: "Camera",
                color: Colors.blue.shade100,
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null && context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultView(image: File(pickedFile.path))),
                    );
                    await _loadRecords();
                  }
                },
              ),
              const SizedBox(height: 12),
              _scanOption(
                assetPath: 'assets/images/picture.png',
                label: "Galeri",
                color: Colors.blue.shade100,
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null && context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultView(image: File(pickedFile.path))),
                    );
                    await _loadRecords();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _scanOption({
    required String assetPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black26),
        ),
        child: Row(
          children: [
            Image.asset(assetPath, width: 24, height: 24, fit: BoxFit.contain),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontFamily: "Poppins", fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
