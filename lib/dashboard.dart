
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:petportal/addmore.dart';
import 'package:petportal/addpet.dart';
import 'package:petportal/chatbot.dart';
import 'package:petportal/select_pet_diet.dart';
import 'package:petportal/remainder.dart';
import 'package:petportal/videotutorial.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C6CF2),
        elevation: 0,
        toolbarHeight: 70,
        title: const Text(
          'Pet Portal',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🐾 My Pets
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Pets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _petAvatar('assets/images/pin.png', 'Bella'),
                        _petAvatar('assets/images/pin1.png', 'Roudy'),
                        _petAvatar('assets/images/pin2.png', 'Furry'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ➕ Add Pet
            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Pets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Addpet()));
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFF0C6CF2),
                          child: Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧩 Services
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _serviceButton(Icons.restaurant_menu, 'Diet plans', 'Nutrition guide', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectPetForDiet()));
                }),
                _serviceButton(Icons.play_circle_fill, 'Training', 'Video tutorial', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoTutorial()));
                }),
                _serviceButton(Icons.chat_bubble_outline, 'Chatbot', 'Get help instantly', () {}),
              ],
            ),

            const SizedBox(height: 24),

            // 🔔 Upcoming Reminders (Latest 2 Only)
            const Text(
              "Upcoming Reminders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            StreamBuilder<DatabaseEvent>(
              stream: _database
                  .child("reminders")
                  .child(_auth.currentUser?.uid ?? "")
                  .onValue,
              builder: (context, snapshot) {

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return _emptyReminderCard();
                }

                final data = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);

                List<Map<dynamic, dynamic>> reminderList = [];

                data.forEach((key, value) {
                  if (value is Map) {
                    reminderList.add({
                      "key": key,
                      ...Map<dynamic, dynamic>.from(value),
                    });
                  }
                });

                // Sort by createdAt descending
                reminderList.sort((a, b) =>
                    (b["createdAt"] ?? 0).compareTo(a["createdAt"] ?? 0));

                final latestTwo = reminderList.length > 2
                    ? reminderList.sublist(0, 2)
                    : reminderList;

                return Column(
                  children: latestTwo.map((reminder) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _reminderCard(
                        reminder["title"] ?? "",
                        reminder["petName"] ?? "",
                        reminder["date"] ?? "",
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),

            // 🛡️ Pet Safety Precautions
            const Text(
              'Pet Safety Precautions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ListTile(
                    leading: Icon(Icons.verified, color: Colors.green),
                    title: Text("Keep vaccines up to date"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.no_food, color: Colors.orange),
                    title: Text("Avoid toxic foods like chocolate"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.pets, color: Colors.blue),
                    title: Text("Use a leash during walks"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.water, color: Colors.cyan),
                    title: Text("Provide clean water daily"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),

      // 🔽 Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0C6CF2),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RemindersScreen()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Addmore()));
          }
          else if(index == 2){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const ChatBot()));
          }

        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'More'),
        ],
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _emptyReminderCard() {
    return _sectionContainer(
      child: const Center(
        child: Text(
          "No upcoming reminders 🐾",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _reminderCard(String title, String petName, String date) {
    return _sectionContainer(
      child: Row(
        children: [
          const Icon(Icons.medical_services, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(petName),
                Text(date, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _petAvatar(String imagePath, String name) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
          const SizedBox(height: 6),
          Text(name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _serviceButton(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: _sectionContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF0C6CF2), size: 36),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}