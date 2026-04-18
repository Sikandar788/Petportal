import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petportal/petform.dart';

class Addpet extends StatefulWidget {
  const Addpet({super.key});

  @override
  State<Addpet> createState() => _PetProfilesScreenState();
}

class _PetProfilesScreenState extends State<Addpet> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🗑 Delete Function
  void deletePet(String petKey) async {
    await _database
        .child("pets")
        .child(_auth.currentUser!.uid)
        .child(petKey)
        .remove();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pet deleted successfully"),
        backgroundColor: Colors.red,
      ),
    );
  }

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
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, size: 22),
              ),
              const SizedBox(height: 8),

              // 🐶 Title and Add Button
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Petform()),
                      );
                    },
                    icon:
                        const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Add Pet',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C6CF2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔥 REALTIME DATABASE FETCH
              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                  stream: _database
                      .child("pets")
                      .child(_auth.currentUser!.uid)
                      .onValue,
                  builder: (context, snapshot) {

                      // 🟡 Loading State
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // 🔴 Error State
                      if (snapshot.hasError) {
                        print('Realtime DB snapshot error (pets): ${snapshot.error}');
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      // 🐾 No Data
                      if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                        return const Center(
                          child: Text("No pets added yet 🐾"),
                        );
                      }

                      final user = _auth.currentUser;
                      if (user == null) {
                        print('No authenticated user while fetching pets');
                        return const Center(child: Text("Please log in to see pets"));
                      }

                      Map<dynamic, dynamic> pets = {};
                      try {
                        final raw = snapshot.data!.snapshot.value;
                        if (raw is Map) {
                          pets = Map<dynamic, dynamic>.from(raw);
                        } else {
                          print('Unexpected pets snapshot type: ${raw.runtimeType}');
                        }
                      } catch (e, st) {
                        print('Error parsing pets snapshot: $e\n$st');
                      }

                      List<Map<dynamic, dynamic>> petList = [];

                      pets.forEach((key, value) {
                        if (value is Map) {
                          petList.add({
                            "key": key,
                            ...Map<dynamic, dynamic>.from(value),
                          });
                        } else {
                          print('Skipping pet entry $key with non-map value: ${value.runtimeType}');
                        }
                      });

                    return ListView.builder(
                      itemCount: petList.length,
                      itemBuilder: (context, index) {
                        final pet = petList[index];

                        return Column(
                          children: [
                            _petCard(
                              'assets/images/pin.png',
                              pet["name"] ?? "",
                              pet["breed"] ?? "",
                              "${pet["age"] ?? 0} years old",
                              pet["gender"] ?? "",
                              pet["key"],
                              pet,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🐾 Pet Card
  Widget _petCard(
    String image,
    String name,
    String breed,
    String age,
    String vaccStatus,
    String petKey,
    Map petData,
  ) {
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                      style:
                          const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // ✏ EDIT
                  _iconButton(Icons.edit_outlined,
                      Colors.blueAccent, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Petform(
                          // Add edit logic in Petform using petData & petKey
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 6),

                  // 🗑 DELETE
                  _iconButton(Icons.delete_outline,
                      Colors.redAccent, () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                        title:
                            const Text("Delete Pet"),
                        content: const Text(
                            "Are you sure you want to delete this pet?"),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                                    context),
                            child:
                                const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              deletePet(petKey);
                              Navigator.pop(
                                  context);
                            },
                            child:
                                const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Age',
                style: TextStyle(
                    color: Colors.grey, fontSize: 13),
              ),
              Text(
                'Gender',
                style: TextStyle(
                    color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(age,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
              Text(vaccStatus,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
      IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18, color: color),
      ),
    );
  }
}
