import 'package:flutter/material.dart';
import 'package:plantsentry/views/home.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Logo
              Image.asset(
                'assets/images/PlantSentry-icon.png',
                width: 60,
                height: 60,
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 16),

              // Deskripsi dengan bold di awal
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "PlantSentry ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextSpan(
                      text:
                          "is A Drone that Monitors the Condition and Health of Plants Using Computer Vision",
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),

              const SizedBox(height: 24),

              // Gambar tanaman
              Image.asset(
                'assets/images/tanaman.png', // ganti dengan gambar tanaman kamu
                width: 220,
              ),

              const SizedBox(height: 60),

              // Tombol Get Started
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageView()),
                );
              },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DBF42), // hijau soft
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Get started",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "already have account? ",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman login
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
