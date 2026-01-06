import 'package:flutter/material.dart';
import 'package:petportal/loginscreen.dart';
import 'package:petportal/registerscreen.dart';


class Loginhome extends StatefulWidget {
  const Loginhome({super.key});

  @override
  State<Loginhome> createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + App name
              Column(
                children: [
                  // You can replace with your logo
                  Icon(Icons.pets, size: 60, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text(
                    "Pet Portal",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Google button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google 2.png', // Add google logo in assets
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    "Login With Google",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Google login
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Apple button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.apple, color: Colors.black, size: 24),
                  label: const Text(
                    "Login With Apple",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Apple login
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Divider with "or"
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[400], thickness: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or"),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[400], thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign in with password
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: const Text(
                    "Sign In with Password",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Register text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t Have An Account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Registerscreen(),));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
