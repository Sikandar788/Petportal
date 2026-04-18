import 'package:flutter/material.dart';

class Aboutscreen extends StatefulWidget {
  const Aboutscreen({super.key});

  @override
  State<Aboutscreen> createState() => _AboutPageState();
}

class _AboutPageState extends State<Aboutscreen> {
  final Color primaryColor = const Color(0xff3F82FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "About",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== HEADER =====
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.pets_rounded,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Pet Portal",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Professional Pet Care Management System",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// ===== ABOUT =====
            buildSection(
              title: "About",
              content:
                  "Pet Portal is a structured and secure pet care management application "
                  "designed to assist pet owners in organizing health records, vaccination schedules, "
                  "training resources, and personalized reminders in one unified platform.",
            ),

            /// ===== MAIN FEATURES =====
            buildSection(
              title: "Main Features",
              content:
                  "• Secure Email & Google Authentication\n"
                  "• Pet Profile & Health Record Management\n"
                  "• Vaccination & Grooming Reminders\n"
                  "• Training Video Tutorials (Cat & Dog)\n"
                  "• Real-time Cloud Data Storage\n"
                  "• Organized Dashboard Experience",
            ),

            /// ===== DATA & PRIVACY =====
            buildSection(
              title: "Data & Privacy",
              content:
                  "Pet Portal prioritizes user data confidentiality. "
                  "All authentication processes are handled securely via Firebase Authentication. "
                  "User data is stored safely in cloud databases and is never shared with third parties.",
            ),

            /// ===== SECURITY =====
            buildSection(
              title: "Security",
              content:
                  "The application integrates secure authentication protocols, "
                  "Google Sign-In, and protected cloud database services "
                  "to ensure account integrity and data protection.",
            ),

            /// ===== SUPPORT =====
            buildSection(
              title: "Support",
              content:
                  "For technical assistance, feature requests, or feedback, "
                  "users may contact the development team via the in-app contact section.",
            ),

            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    "© 2026 Pet Portal",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "All Rights Reserved",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
