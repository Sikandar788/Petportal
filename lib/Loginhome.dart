import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petportal/dashboard.dart';
import 'package:petportal/loginscreen.dart';
import 'package:petportal/registerscreen.dart';


class Loginhome extends StatefulWidget {
  const Loginhome({super.key});

  @override
  State<Loginhome> createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  final GetStorage _storage = GetStorage();

  RxBool isSocialLoginLoading = false.obs;
  
  RxString userRole = 'owner'.obs; // default role, can adjust after login

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    _googleSignIn = GoogleSignIn.instance;

    // Use the correct client IDs from Firebase configuration
    await _googleSignIn.initialize(
      clientId: Platform.isIOS
          ? "26343599080-clojmsq3r6bp0rq59bpj0hdpdbr8135p.apps.googleusercontent.com"
          : "26343599080-clojmsq3r6bp0rq59bpj0hdpdbr8135p.apps.googleusercontent.com",
      serverClientId: Platform.isIOS
          ?  "26343599080-clojmsq3r6bp0rq59bpj0hdpdbr8135p.apps.googleusercontent.com"
          :  "26343599080-clojmsq3r6bp0rq59bpj0hdpdbr8135p.apps.googleusercontent.com",
    );

    // Listen to authentication events
    _googleSignIn.authenticationEvents.listen((event) {
      _user = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };
    
    });
  }

  
 Future<void> loginWithGoogle() async {
  try {
    isSocialLoginLoading.value = true;
    print("object11");

    if (_googleSignIn.supportsAuthenticate()) {
      await _googleSignIn.authenticate(scopeHint: ['email']);
    } else {
      return;
    }
    print("object22");

    // Wait briefly to ensure authenticationEvents listener populates _user
    await Future.delayed(Duration(milliseconds: 200));
    print("object33");
    if (_user == null) {
      return;
    }
    print("object44");

    final googleAuth = _user!.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.idToken;
    print("object55");
    if (idToken == null) {
      return;
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    log(' [HOPETSIT] 🔐 Signing in with Google credential');
    await _auth.signInWithCredential(credential);

    // Firebase user
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      // Optional: store ID token or role
      final String? firebaseIdToken = await firebaseUser.getIdToken(true);
      await _storage.write('authToken', firebaseIdToken);
      await _storage.write('userRole', userRole.value);

      // Navigate to Dashboard after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }

  } catch (e) {
    print("Google Login Error: $e");
  } finally {
    isSocialLoginLoading.value = false;
  }
}

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
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset(
                        'assets/images/google 2.png',
                        height: 24,
                        width: 24,
                      ),
                      label: isSocialLoginLoading.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "Login With Google",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: loginWithGoogle,
                    ),
                  )),

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registerscreen()));
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
