
import 'package:flutter/material.dart';
import 'package:petportal/all.dart';

class VideoTutorial extends StatefulWidget {
  const VideoTutorial({super.key});

  @override
  State<VideoTutorial> createState() => _VideoTutorialState();
}

class _VideoTutorialState extends State<VideoTutorial> {
  String selectedCategory = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        centerTitle: true,
        title: const Text(
          "Pet Portal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        // POPUP MENU AT APPBAR RIGHT CORNER
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),

            // NO PROFILE, NO SETTINGS — EMPTY MENU
            itemBuilder: (context) => [],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORY BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                categoryButton("All", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const All()));
                }),
                categoryButton("Dogs", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Placeholder()));
                }),
                categoryButton("Cats", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Placeholder()));
                }),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Video Tutorials",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            cardWidget(
              title: "How to Train Your Dog",
              subtitle: "Beginner friendly guide",
            ),

            cardWidget(
              title: "Cat Grooming Tips",
              subtitle: "Keep your cat healthy",
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY BUTTON
  Widget categoryButton(String text, VoidCallback onTap) {
    bool isActive = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff3F82FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // VIDEO CARD
  Widget cardWidget({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const Icon(Icons.play_circle_fill,
              color: Color(0xff3F82FF), size: 32),
        ],
      ),
    );
  }
}
