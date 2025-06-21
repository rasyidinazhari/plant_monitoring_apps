import 'package:flutter/material.dart';
import 'package:plantsentry/views/camera.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8DBF42), // Hijau soft
        onPressed: () {
          _showScanOptions(context);
        },
        child: const Icon(Icons.local_florist_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header profil
              Row(
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
                          Text(
                            "Hai, Bungg!",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Good Parents!",
                            style: TextStyle(
                              fontFamily: "PoppinsBold",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      print("halo");
                    },
                    icon: const Icon(Icons.tune_rounded, color: Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Record",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Apple
              _buildPlantCard(
                iconWidget: const Icon(Icons.apple, size: 40, color: Colors.red),
                label: "Apple",
                status: "Good",
              ),

              // Cactus
              _buildPlantCard(
                iconWidget: const Icon(Icons.eco, size: 40, color: Colors.green),
                label: "Cactus",
                status: "Good",
              ),

              // Carrot (pakai gambar asset)
              _buildPlantCard(
                iconWidget: Image.asset(
                  'assets/images/carrot.png',
                  width: 40,
                  height: 40,
                ),
                label: "Carrot",
                status: "Good",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantCard({
    required Widget iconWidget,
    required String label,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scan with",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PoppinsBold",
                ),
              ),
              const SizedBox(height: 16),

              _scanOption(
                assetPath: 'assets/images/drone-camera.png',
                label: "Drone",
                color: Colors.blue.shade100,
                onTap: () {
                  Navigator.pop(context);
                  print("Scan via Drone");
                },
              ),
              const SizedBox(height: 12),
              _scanOption(
                assetPath: 'assets/images/camera.png',
                label: "Camera",
                color: Colors.blue.shade100,
                onTap: () {
                Navigator.pop(context); // Menutup popup/modal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanView(),
                ),
                );
              },
              ),
              const SizedBox(height: 12),
              _scanOption(
                assetPath: 'assets/images/picture.png',
                label: "Galeri",
                color: Colors.blue.shade100,
                onTap: () {
                  Navigator.pop(context);
                  print("Scan via Galeri");
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
          Image.asset(
            assetPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
}