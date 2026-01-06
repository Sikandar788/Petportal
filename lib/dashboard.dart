import 'package:flutter/material.dart';
import 'package:petportal/addmore.dart';
import 'package:petportal/addpet.dart';
import 'package:petportal/dietplan.dart';
import 'package:petportal/remainder.dart';
import 'package:petportal/videotutorial.dart';

// These are the new screens (you can replace them later with your own pages)


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C6CF2),
        elevation: 0,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Pet Portal,',
            style: TextStyle(
              
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),   
          ),       
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐾 My Pets Section
            Container(
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

            // 🐕 My Pets + Add Pet Button
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Pets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Addpet()));
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0C6CF2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
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
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/pin.png'),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Max',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Golden Retriever',
                                  style: TextStyle(color: Colors.grey)),
                              Text('3 years old',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ✨ 4 Feature Buttons (Clickable)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _serviceButton(Icons.restaurant_menu, 'Diet plans', 'Nutrition guide', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DietPlan(),));
                
                }),
                _serviceButton(Icons.play_circle_fill, 'Training', 'Video tutorial', () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => VideoTutorial(),));
                 
                }),
                _serviceButton(Icons.vaccines, 'Vaccination', 'Vaccinations', () {
                  
                }),
                _serviceButton(Icons.chat_bubble_outline, 'Chatbot', 'Get help instantly', () {
                
                }),
              ],
            ),
            const SizedBox(height: 24),

            // 📝 Upcoming Reminders
            const Text(
              'Upcoming Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _reminderCard('Annual vaccination', 'Max', '19/01/2025'),
            const SizedBox(height: 10),
            _reminderCard('Vet Check-up', 'Roudy', '23/02/2025'),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // 🔽 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0C6CF2),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Addmore()));
          }else if(index == 1){

          }else if(index == 2){
           Navigator.push(context, MaterialPageRoute(builder:(context) => RemindersScreen(),));
          }else if(index == 3){

          }else if(index == 0){

          }

          
          
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'More'),
        ],
      ),
    );
  }

  Widget _petAvatar(String imagePath, String name) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(height: 6),
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ✅ Updated: Now accepts onTap for navigation
  Widget _serviceButton(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        padding: const EdgeInsets.all(14),
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

  Widget _reminderCard(String title, String petName, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text('$petName • $date',
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Vaccinate',
                style: TextStyle(
                  color: Color(0xFF0C6CF2),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
