
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petportal/loginscreen.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChecked = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Show popup
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showMsg("All fields are required!");
      return;
    }

    if (password != confirm) {
      showMsg("Passwords do not match!");
      return;
    }

    if (!_isChecked) {
      showMsg("Please agree to Terms & Privacy Policy");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showMsg("Account created! Please login.");
         Navigator.pushReplacement(
             context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );

      
    } on FirebaseAuthException catch (e) {
  showMsg(e.message ?? "Registration failed");
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Align(
                alignment: Alignment.topRight,
                child: ClipPath(
                  clipper: CustomTopClipper(),
                  child: Container(
                    height: 120,
                    width: 120,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Welcome !",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("Sign Up To Continue Caring For Your Pet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey)
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: "Email Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (v) {
                            setState(() {
                              _isChecked = v ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "By Continuing, I Agree To The Terms And Privacy Policy",
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Create Account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text("Login",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.7, 0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
