import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:fl_chart/fl_chart.dart';
import 'diet_detail.dart';

class DummyDietScreen extends StatelessWidget {
  final Map<String, dynamic> pet;
  const DummyDietScreen({super.key, required this.pet});

  num _computeRER(double wKg) {
    return 70 * Math.pow(wKg, 0.75);
  }

  // multiplier by life stage
  double _lifeStageFactor(String species, String category) {
    // species: dog/cat, category: puppy/kitten/adult
    if (category == 'puppy' || category == 'kitten') return 2.8;
    // adult default
    return 1.4;
  }

  String _categoryFromPet(Map<String, dynamic> pet) {
    final type = (pet['petType'] ?? '').toString().toLowerCase();
    final ageRaw = pet['age'];
    double age = 0;
    if (ageRaw is num) age = ageRaw.toDouble();
    else age = double.tryParse('$ageRaw') ?? 0;

    if (type == 'dog') return (age < 1) ? 'puppy' : 'adult';
    if (type == 'cat') return (age < 1) ? 'kitten' : 'adult';
    return 'adult';
  }

  @override
  Widget build(BuildContext context) {
    final name = pet['name'] ?? 'Your pet';
    final species = (pet['petType'] ?? 'pet').toString().toLowerCase();
    final category = _categoryFromPet(pet);
    final weight = (pet['weight'] is num) ? (pet['weight'] as num).toDouble() : double.tryParse('${pet['weight']}');

    // compute estimated daily calories
    double estimatedKcal = 0;
    if (weight != null && weight > 0) {
      final rer = 70 * Math.pow(weight, 0.75);
      final factor = _lifeStageFactor(species, category);
      estimatedKcal = rer * factor;
    } else {
      // fallback estimates if no weight: use typical defaults
      if (species == 'cat') estimatedKcal = (category == 'kitten') ? 300 : 260;
      else estimatedKcal = (category == 'puppy') ? 450 : 700;
    }

    // Build two meals split roughly 50/50
    final breakfastKcal = (estimatedKcal * 0.5).round();
    final dinnerKcal = (estimatedKcal * 0.5).round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C6CF2),
        title: Text('Diet Preview — $name'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Recommended daily overview',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('${species.toUpperCase()} • ${category[0].toUpperCase()}${category.substring(1)}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Daily Nutrients & Calories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${estimatedKcal.round()} kcal', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text('Approx. per day', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _legend(Colors.amber, 'Carbs'),
                                const SizedBox(height: 8),
                                _legend(Colors.blue, 'Fats'),
                                const SizedBox(height: 8),
                                _legend(Colors.pink, 'Proteins'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              _mealCard(title: 'Breakfast', meal: 'Meal 1', food: (species == 'cat') ? 'Kibble / Wet mix' : 'Kibble / Chicken', time: '08:00 AM', calories: '${breakfastKcal} kcal'),
              const SizedBox(height: 12),
              _mealCard(title: 'Dinner', meal: 'Meal 2', food: (species == 'cat') ? 'Wet food' : 'Cooked meat + rice', time: '06:00 PM', calories: '${dinnerKcal} kcal'),

              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => DietDetailScreen(pet: pet)),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C6CF2)),
                    child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Show recommended plan')),
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(children: [Container(height: 10, width: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))), const SizedBox(width: 6), Text(text, style: const TextStyle(fontSize: 12))]);
  }

  Widget _mealCard({required String title, required String meal, required String food, required String time, required String calories}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
      child: Row(children: [const Icon(Icons.wb_sunny_outlined), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(meal, style: const TextStyle(fontSize: 12, color: Colors.grey)), const SizedBox(height: 6), Text('Food: $food', style: const TextStyle(fontSize: 12)), Text('Time: $time', style: const TextStyle(fontSize: 12))])), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.pink.shade100, borderRadius: BorderRadius.circular(20)), child: Text(calories, style: const TextStyle(fontSize: 12))) ]),
    );
  }
}
