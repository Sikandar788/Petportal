import 'package:flutter/material.dart';
import 'package:petportal/petform.dart';

class Addpet extends StatefulWidget {
  const Addpet({super.key});

  @override
  State<Addpet> createState() => _PetProfilesScreenState();
}

class _PetProfilesScreenState extends State<Addpet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, size: 22),
              ),
              const SizedBox(height: 8),

              // 🐶 Title and Add Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Profiles',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your pet’s information',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => Petform(),));
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Add Pet',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6CF2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🐕 Pet Cards
              Expanded(
                child: ListView(
                  children: [
                    _petCard('assets/images/pin.png', 'Max', 'Golden Retriever',
                        '3 years old', 'Need attention'),
                    const SizedBox(height: 16),
                    _petCard('assets/images/pin.png', 'Max', 'Golden Retriever',
                        '3 years old', 'Need attention'),
                    const SizedBox(height: 16),
                    _petCard('assets/images/pin.png', 'Max', 'Golden Retriever',
                        '3 years old', 'Need attention'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🐾 Pet Card Widget
  Widget _petCard(String image, String name, String breed, String age, String vaccStatus) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Column(
        children: [
          // First Row: Image + Name + Edit/Delete Icons
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.amber.shade100,
                backgroundImage: AssetImage(image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      breed,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _iconButton(Icons.edit_outlined, Colors.blueAccent, () {}),
                  const SizedBox(width: 6),
                  _iconButton(Icons.delete_outline, Colors.redAccent, () {}),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),

          // Second Row: Age and Vaccination info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Age',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Text(
                'Vaccination',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(age,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14)),
              Text(vaccStatus,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // ✏️ Reusable small icon button
  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
