
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petportal/onboarding_screens.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds then go to onboarding
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B5AFE), // same blue tone
      body: Stack(
        children: [
          // Top-left paw watermark
          Positioned(
            top: 40,
            left: -20,
            child: Opacity(
              opacity: 0.08,
              child: Transform.rotate(
                angle: 0.5,
                child: Icon(
                  Icons.pets,
                  size: 180,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Bottom-right paw watermark
          Positioned(
            bottom: 40,
            right: -20,
            child: Opacity(
              opacity: 0.08,
              child: Transform.rotate(
                angle: 0.5,
                child: Icon(
                  Icons.pets,
                  size: 180,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Center text + small paw above "P"
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, size: 26, color: Colors.white),
                const SizedBox(height: 4),
                const Text(
                  "Pet Portal",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
