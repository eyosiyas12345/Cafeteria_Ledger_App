import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // NEW IMPORT
import 'package:helloworld/pages/auth/singup.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formGlobalKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- Logic: Email/Password Login ---
  Future<void> _loginWithEmail() async {
    if (_formGlobalKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed")));
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      // Logic: Use the same Popup provider as the SignUp page for consistency
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // 1. Trigger the popup
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // 2. Navigate if successful
      if (userCredential.user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // Helpful for debugging the 'messy text' or cancelled popups
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Login Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("WELCOME",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email:", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty || !value.contains("@")
                      ? "Invalid email"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty || value.length < 8
                      ? "Incorrect password"
                      : null,
                ),
                const SizedBox(height: 20),

                FilledButton(
                  onPressed: _loginWithEmail,
                  style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Login"),
                ),

                const SizedBox(height: 20),
                const Text("OR", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // Working Google Button
                OutlinedButton.icon(
                  onPressed: _loginWithGoogle, // CALLING THE NEW FUNCTION
                  icon: const Icon(Icons.account_circle, color: primaryColor),
                  label: const Text("Continue with Google"),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                ),

                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage())),
                  child: const Text("Don't have an account? Create one"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
