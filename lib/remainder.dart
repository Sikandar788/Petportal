import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addremainder.dart';
import 'loginscreen.dart';
import 'dashboard.dart';
import 'addmore.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  int _currentIndex = 1; // Health screen selected by default

  void deleteReminder(String reminderKey) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _database
        .child("reminders")
        .child(user.uid)
        .child(reminderKey)
        .remove();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reminder deleted successfully"),
        backgroundColor: Colors.red,
      ),
    );
  }

  Map<dynamic, dynamic> _mapFromSnapshot(Object? value) {
    if (value == null) return {};
    if (value is Map) return Map<dynamic, dynamic>.from(value);
    try {
      return Map<dynamic, dynamic>.from(value as Map);
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        body: const Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pet Portal",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Health Reminders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF0C6CF2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddReminderPage(),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Reminder Count
            StreamBuilder<DatabaseEvent>(
              stream: _database.child("reminders").child(user.uid).onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Text("Upcoming (0)",
                      style: TextStyle(fontWeight: FontWeight.bold));
                }

                final reminders =
                    _mapFromSnapshot(snapshot.data!.snapshot.value);

                return Text(
                  "Upcoming (${reminders.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),

            const SizedBox(height: 12),

            // Reminder List
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream:
                    _database.child("reminders").child(user.uid).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(
                        child: Text("No reminders added yet"));
                  }

                  final reminders =
                      _mapFromSnapshot(snapshot.data!.snapshot.value);

                  List<Map<dynamic, dynamic>> reminderList = [];
                  reminders.forEach((key, value) {
                    if (value is Map) {
                      reminderList.add({
                        "key": key,
                        ...Map<dynamic, dynamic>.from(value),
                      });
                    }
                  });

                  return ListView.builder(
                    itemCount: reminderList.length,
                    itemBuilder: (context, index) {
                      final reminder = reminderList[index];
                      return _reminderCard(reminder);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🔵 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0C6CF2),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            // Already on Health
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChatPlaceholderScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const Addmore()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety), label: "Health"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: "Chatbot"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "More"),
        ],
      ),
    );
  }

  Widget _reminderCard(Map reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.medical_services, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder["title"] ?? "",
                  style:
                      const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(reminder["petName"] ?? ""),
                Text(reminder["date"] ?? "",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deleteReminder(reminder["key"]);
            },
          ),
        ],
      ),
    );
  }
}

// Temporary Chatbot Screen
class ChatPlaceholderScreen extends StatelessWidget {
  const ChatPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        backgroundColor: const Color(0xFF0C6CF2),
      ),
      body: const Center(
        child: Text(
          "Chatbot Coming Soon...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}