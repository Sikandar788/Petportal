
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // ✅ UPDATED APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profile', child: Text('Profile')),
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
        ),
        title: const Text(
          "Pet Portal",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ HEALTH REMINDER TITLE + ADD BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Health Reminders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ✅ TRACK TEXT BELOW
            const Text(
              "Track vaccination and healthcare schedules",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: const [
                Icon(Icons.notifications, size: 18),
                SizedBox(width: 6),
                Text(
                  "Upcoming (3)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _reminderCard(),
            _reminderCard(),
            _reminderCard(),

            const SizedBox(height: 20),

            Row(
              children: const [
                Icon(Icons.favorite, size: 18),
                SizedBox(width: 6),
                Text(
                  "Health Tips",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _tipCard(
              title: "Vaccination Schedule",
              description:
                  "Puppies need vaccinations at 6-8 weeks, 10-12 weeks, and 14-16 weeks.\nAdult dogs need boosters.",
            ),

            _tipCard(
              title: "Deworming",
              description:
                  "Deworm puppies every 2-3 weeks until 6 months old, then every 3-6 months for adult dogs.",
            ),

            _tipCard(
              title: "Regular Checkups",
              description:
                  "Annual health checkups help detect issues early. Senior pets (7+ years) should see the vet twice yearly.",
            ),
          ],
        ),
      ),
    );
  }

  // 🔔 REMINDER CARD
  static Widget _reminderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.medical_services, color: Colors.redAccent),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Annual vaccination",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  "DHPP, Rabies vaccination due",
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 4),
                    const Text(
                      "14/01/2025",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "247 days overdue",
                        style: TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(Icons.check_circle, color: Colors.blue),
        ],
      ),
    );
  }

  // 💡 HEALTH TIP CARD
  static Widget _tipCard({
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
