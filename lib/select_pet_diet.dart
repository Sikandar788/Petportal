import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diet_detail.dart';
import 'dummy_diet.dart';

class SelectPetForDiet extends StatefulWidget {
  const SelectPetForDiet({super.key});

  @override
  State<SelectPetForDiet> createState() => _SelectPetForDietState();
}

class _SelectPetForDietState extends State<SelectPetForDiet> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'User not signed in';
          _loading = false;
        });
        return;
      }

      final snap = await _db.child('pets').child(user.uid).get();
      if (!snap.exists) {
        setState(() {
          _pets = [];
          _loading = false;
        });
        return;
      }

      final raw = snap.value as Map<dynamic, dynamic>;
      final list = raw.entries.map((e) {
        final m = Map<String, dynamic>.from(e.value as Map);
        m['__key'] = e.key;
        return m;
      }).toList();

      setState(() {
        _pets = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load pets: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Pet'),
        backgroundColor: const Color(0xFF0C6CF2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : _pets.isEmpty
                      ? const Center(child: Text('No pets found. Add a pet first.'))
                      : ListView.builder(
                          itemCount: _pets.length,
                          itemBuilder: (_, i) {
                            final pet = _pets[i];
                            final name = pet['name'] ?? 'Unnamed';
                            final breed = pet['breed'] ?? '';
                            final type = pet['petType'] ?? '';
                            final age = pet['age']?.toString() ?? '';
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.pets)),
                                title: Text(name),
                                subtitle: Text('$type • $breed • ${age}'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DummyDietScreen(pet: pet),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
