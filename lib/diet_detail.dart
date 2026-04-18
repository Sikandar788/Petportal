import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DietDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pet;
  const DietDetailScreen({super.key, required this.pet});

  @override
  State<DietDetailScreen> createState() => _DietDetailScreenState();
}

class _DietDetailScreenState extends State<DietDetailScreen> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _selectedPlan;

  @override
  void initState() {
    super.initState();
    _loadPlan();
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

  Future<void> _loadPlan() async {
    try {
      final pet = widget.pet;
      final species = (pet['petType'] ?? 'dog').toString().toLowerCase();
      final category = _categoryFromPet(pet);

      final snap = await _db.child('diet_plans').child(species).child(category).get();
      if (!snap.exists) {
        setState(() {
          _error = 'No diet plans found for $species/$category';
          _loading = false;
        });
        return;
      }

      final plansRaw = Map<String, dynamic>.from(snap.value as Map);

      // Normalize pet info
      final petWeight = (pet['weight'] is num) ? (pet['weight'] as num).toDouble() : double.tryParse('${pet['weight']}');
      final petAgeYears = (pet['age'] is num) ? (pet['age'] as num).toDouble() : double.tryParse('${pet['age']}');
      final petAgeMonths = (petAgeYears != null) ? (petAgeYears * 12.0) : null;

      // If exact match by ranges exists pick it; otherwise compute nearest-plan by distance
      Map<String, dynamic>? exactMatch;
      final List<MapEntry<String, dynamic>> entries = plansRaw.entries.toList();

      for (final entry in entries) {
        final p = Map<String, dynamic>.from(entry.value as Map);
        bool ageOk = true;
        bool weightOk = true;

        // Age check (months or years)
        if (petAgeYears != null) {
          if (p.containsKey('min_age_months') || p.containsKey('max_age_months')) {
            final minA = (p['min_age_months'] ?? -99999) as num;
            final maxA = (p['max_age_months'] ?? 999999) as num;
            if (petAgeMonths != null) {
              ageOk = petAgeMonths >= minA && petAgeMonths <= maxA;
            }
          } else if (p.containsKey('min_age_years') || p.containsKey('max_age_years')) {
            final minY = (p['min_age_years'] ?? -99999) as num;
            final maxY = (p['max_age_years'] ?? 999999) as num;
            ageOk = petAgeYears >= minY && petAgeYears <= maxY;
          }
        }

        // Weight check
        if (petWeight != null && (p.containsKey('weight_min_kg') || p.containsKey('weight_max_kg'))) {
          final minW = (p['weight_min_kg'] ?? -99999) as num;
          final maxW = (p['weight_max_kg'] ?? 999999) as num;
          weightOk = petWeight >= minW && petWeight <= maxW;
        }

        if (ageOk && weightOk) {
          exactMatch = p;
          break;
        }
      }

      if (exactMatch != null) {
        setState(() {
          _selectedPlan = exactMatch;
          _loading = false;
        });
        return;
      }

      // No exact match; compute nearest plan by distance (age + weight)
      double bestScore = double.infinity;
      Map<String, dynamic>? bestPlan;

      for (final entry in entries) {
        final p = Map<String, dynamic>.from(entry.value as Map);
        double score = 0.0;
        double ageWeight = 0.6; // importance of age vs weight
        double weightWeight = 0.4;

        // Age distance
        if (petAgeYears != null) {
          if (p.containsKey('min_age_months') || p.containsKey('max_age_months')) {
            final minA = (p['min_age_months'] ?? -99999) as num;
            final maxA = (p['max_age_months'] ?? 999999) as num;
            final mid = ((minA + maxA) / 2.0);
            final petM = petAgeMonths ?? petAgeYears * 12.0;
            score += ageWeight * ( ( (petM - mid).abs() ) / ( (maxA - minA).abs() + 1 ) );
          } else if (p.containsKey('min_age_years') || p.containsKey('max_age_years')) {
            final minY = (p['min_age_years'] ?? -99999) as num;
            final maxY = (p['max_age_years'] ?? 999999) as num;
            final mid = ((minY + maxY) / 2.0);
            score += ageWeight * ( (petAgeYears - mid).abs() / ( (maxY - minY).abs() + 1 ) );
          } else {
            // plan has no age data, small penalty
            score += ageWeight * 1.0;
          }
        } else {
          // no pet age known, add neutral penalty
          score += ageWeight * 1.0;
        }

        // Weight distance
        if (petWeight != null) {
          if (p.containsKey('weight_min_kg') || p.containsKey('weight_max_kg')) {
            final minW = (p['weight_min_kg'] ?? 0) as num;
            final maxW = (p['weight_max_kg'] ?? 0) as num;
            final mid = ((minW + maxW) / 2.0);
            score += weightWeight * ( (petWeight - mid).abs() / ( (maxW - minW).abs() + 1 ) );
          } else {
            // plan has no weight data
            score += weightWeight * 1.0;
          }
        } else {
          // missing pet weight => give small penalty but allow age-driven selection
          score += weightWeight * 0.8;
        }

        if (score < bestScore) {
          bestScore = score;
          bestPlan = p;
        }
      }

      setState(() {
        _selectedPlan = bestPlan ?? entries.first.value as Map<String, dynamic>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading plan: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pet['name'] ?? 'Pet'} - Diet'),
        backgroundColor: const Color(0xFF0C6CF2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : _selectedPlan == null
                      ? const Center(child: Text('No suitable plan'))
                      : _planView(),
        ),
      ),
    );
  }

  Widget _planView() {
    final plan = _selectedPlan!;
    final meals = (plan['meals'] as List?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plan['title'] ?? 'Diet Plan', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Calories/day: ${plan['calories_per_day'] ?? '-'}', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: meals.length,
            itemBuilder: (_, i) {
              final m = Map<String, dynamic>.from(meals[i] as Map);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Food: ${m['food'] ?? ''}'),
                      Text('Amount: ${m['amount'] ?? ''}'),
                      Text('Calories: ${m['kcal'] ?? ''}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
