import 'package:flutter/material.dart';
import 'package:petportal/Loginhome.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/pic1.png",
      "title": "Now !",
      "desc":
          "One tap for foods, accessories, health care products & digital gadgets\n\nEasy & best consultation bookings"
    },
    {
      "image": "assets/images/pic2.png",
      "title": "Track Health",
      "desc":
          "Stay updated with vaccinations, medications, and medical records."
    },
    {
      "image": "assets/images/pic3.png",
      "title": "Get Started",
      "desc":
          "Enjoy the best pet care experience with Pet Portal. Manage everything in one place!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // Full background image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(onboardingData[index]["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Bottom white rounded container
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Page indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (dotIndex) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 6,
                            decoration: BoxDecoration(
                              color: currentIndex == dotIndex
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        onboardingData[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        onboardingData[index]["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Buttons
                      if (index != onboardingData.length - 1) ...[
                        // Next button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _controller.nextPage(
                                duration:
                                    const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Next",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios,
                                    size: 18, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Skip button
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginhome(),));
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ] else ...[
                        // Last screen: Get Started button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Loginhome() ,));
                            },
                            child: const Text(
                              "Get Started",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
