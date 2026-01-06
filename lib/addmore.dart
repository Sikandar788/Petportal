import 'package:flutter/material.dart';
import 'package:petportal/dashboard.dart';
import 'package:petportal/remainder.dart';

class Addmore extends StatefulWidget {
  const Addmore({super.key});

  @override
  State<Addmore> createState() => _AddmoreState();
}

class _AddmoreState extends State<Addmore> {
  int currentIndex=4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),

              // Title and Subtitle
              const Center(
                child: Column(
                  children: [
                    Text(
                      "More Options",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Additional information and support",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // About Pet Portal
              _OptionCard(
                icon: Icons.info_outline_rounded,
                title: "About Pet Portal",
                subtitle: "Learn about our mission and features",
                iconColor: Colors.blueAccent,
                onTap: () {
                  // TODO: Navigate to About page
                },
              ),
              const SizedBox(height: 16),

              // Contact Support
              _OptionCard(
                icon: Icons.phone_rounded,
                title: "Contact Support",
                subtitle: "Get help and send us feedback",
                iconColor: Colors.amber,
                onTap: () {
                  // TODO: Navigate to Contact Support page
                },
              ),
              const SizedBox(height: 16),

              // Account Settings
              _OptionCard(
                icon: Icons.logout_rounded,
                title: "Account Settings",
                subtitle: "Manage your account and preferences",
                iconColor: Colors.pinkAccent,
                trailing: const Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  // TODO: Add Sign Out functionality
                },
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0C6CF2),
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            if(index==0){
              Navigator.push(context, MaterialPageRoute(builder:(context) => DashboardScreen(),));
            }else if(index==1){

            }else if(index==2){
              Navigator.push(context, MaterialPageRoute(builder:(context) => RemindersScreen(),));
            }else if(index==3){

            }else if(index==4){
       
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
}

// Reusable Option Card Widget
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              // Icon Container
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing Arrow or Text (like “Sign Out”)
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
