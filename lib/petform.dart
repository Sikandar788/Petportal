import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petportal/viewpet.dart';
import 'package:firebase_database/firebase_database.dart';

class Petform extends StatefulWidget {
  const Petform({super.key});

  @override
  State<Petform> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<Petform> {

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedPetType;
  String? selectedBreed;
  String? selectedGender;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> addPet() async {
  //   if (selectedPetType == null ||
  //       nameController.text.isEmpty ||
  //       selectedBreed == null ||
  //       ageController.text.isEmpty ||
  //       weightController.text.isEmpty ||
  //       selectedGender == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please fill all fields")),
  //     );
  //     return;
  //   }

  //   await _firestore.collection("pets").add({
  //     "petType": selectedPetType,
  //     "name": nameController.text.trim(),
  //     "breed": selectedBreed,
  //     "age": ageController.text.trim(),
  //     "weight": weightController.text.trim(),
  //     "gender": selectedGender,
  //     "userId": _auth.currentUser!.uid,
  //     "createdAt": Timestamp.now(),
  //   });

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const Viewpet()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Add New Pet",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Fill in your pet’s information to create their profile.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // 🔹 PET TYPE
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.pets),
                    hintText: "Select Pet Type",
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Dog", child: Text("Dog")),
                    DropdownMenuItem(value: "Cat", child: Text("Cat")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPetType = value;
                      selectedBreed = null;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 🔹 PET NAME
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.pets_outlined),
                    hintText: "Enter pet’s name",
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 BREED (Dog / Cat Separate)
                DropdownButtonFormField<String>(
                  value: selectedBreed,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category_outlined),
                    hintText: "Breed",
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: selectedPetType == "Dog"
                      ? const [
                          DropdownMenuItem(value: "Golden Retriever", child: Text("Golden Retriever")),
                          DropdownMenuItem(value: "Bulldog", child: Text("Bulldog")),
                          DropdownMenuItem(value: "German Shepherd", child: Text("German Shepherd")),
                        ]
                      : selectedPetType == "Cat"
                          ? const [
                              DropdownMenuItem(value: "Persian", child: Text("Persian")),
                              DropdownMenuItem(value: "Siamese", child: Text("Siamese")),
                              DropdownMenuItem(value: "Maine Coon", child: Text("Maine Coon")),
                            ]
                          : [],
                  onChanged: (value) {
                    setState(() {
                      selectedBreed = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 🔹 AGE & WEIGHT
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.hourglass_bottom_outlined),
                          hintText: "Age",
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.scale_outlined),
                          hintText: "Weight",
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 GENDER
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people_outline),
                    hintText: "Select gender",
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                  ],
                  onChanged: (value) {
                    selectedGender = value;
                  },
                ),

                const SizedBox(height: 24),

                // 🔹 BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: addPet,
                        child: const Text("Add Pet"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPet() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        const msg = "You must be signed in to add a pet";
        print(msg);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
        return;
      }

      String userId = user.uid;

      DatabaseReference petRef = FirebaseDatabase.instance.ref().child("pets").child(userId).push();

      await petRef.set({
        "petId": petRef.key,
        "petType": selectedPetType ?? "",
        "name": nameController.text.trim(),
        "breed": selectedBreed ?? "",
        "age": int.tryParse(ageController.text.trim()) ?? 0,
        "weight": double.tryParse(weightController.text.trim()) ?? 0.0,
        "gender": selectedGender ?? "",
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pet added successfully 🐾"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Viewpet()),
      );
    } on FirebaseException catch (e) {
      print('FirebaseException in addPet: ${e.code} ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Firebase error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e, st) {
      print('Error in addPet: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}