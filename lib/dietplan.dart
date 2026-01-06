import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:petportal/dashboard.dart';

class DietPlan extends StatefulWidget {
  const DietPlan({super.key});

  @override
  State<DietPlan> createState() => _DietPlanState();
}

class _DietPlanState extends State<DietPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 BACK BUTTON
              IconButton(
  icon: const Icon(Icons.arrow_back_ios),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  },
),

              const SizedBox(height: 10),

              // 🥗 TITLE
              const Text(
                "Diet Plan Schedule",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              const Text(
                "Daily diet recommendations for your pet’s well-being",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // 📊 CALORIES CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    const Text(
                      "Daily Nutrients & Calories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      "Calculation",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 16),

                    // ✅ REAL PIE CHART (DESIGN SAME)
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              centerSpaceRadius: 45,
                              sectionsSpace: 2,
                              sections: [
                                PieChartSectionData(
                                  value: 43,
                                  color: Colors.pink,
                                  radius: 55,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 35,
                                  color: Colors.amber,
                                  radius: 55,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 22,
                                  color: Colors.blue,
                                  radius: 55,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "900 kcal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 🧾 LEGENDS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _legend(Colors.amber, "Carbs"),
                        _legend(Colors.blue, "Fats"),
                        _legend(Colors.pink, "Proteins"),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Total Calories: 900 kcal",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🍳 BREAKFAST CARD
              _mealCard(
                title: "Breakfast",
                meal: "Meal1",
                food: "Bone/Fish",
                time: "8:00 AM",
                calories: "450 kcal",
              ),

              const SizedBox(height: 14),

              // 🍽 DINNER CARD
              _mealCard(
                title: "Dinner",
                meal: "Meal2",
                food: "Bone/Fish",
                time: "8:00 AM",
                calories: "450 kcal",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 LEGEND WIDGET
  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // 🍴 MEAL CARD
  Widget _mealCard({
    required String title,
    required String meal,
    required String food,
    required String time,
    required String calories,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(meal,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text("Food: $food",
                    style: const TextStyle(fontSize: 12)),
                Text("Time: $time",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              calories,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
