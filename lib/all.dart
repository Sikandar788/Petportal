
import 'package:flutter/material.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // =============== APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // Back Button (Popup removed)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Training pets",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // =============== BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Example Training Video Card
          _trainingCard(
            title: "Basic Obedience Training",
            description: "Sit, Stay, Come training for all pets.",
            onTap: () {},
          ),

          _trainingCard(
            title: "food Training",
            description: "Teach your pet how to eat & drink.",
            onTap: () {},
          ),

          _trainingCard(
            title: "Leash Training",
            description: "Learn how to walk with your pet on a leash.",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Reusable widget for training video cards
  Widget _trainingCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill, size: 40, color: Colors.blue),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
