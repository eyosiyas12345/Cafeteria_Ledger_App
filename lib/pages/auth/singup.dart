import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helloworld/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:helloworld/pages/auth/login.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formGlobalKey = GlobalKey<FormState>();
  File? _image;

//function for google authentication
  Future<void> handleGoogleSignIn() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    try {
      // This triggers the Google Popup
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // If successful, navigate to the MainScreen
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // Show an error if something goes wrong (like the user closing the popup)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: $e")),
      );
    }
  }

//function for image picking from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(context) {
    // FIX 1: Add Scaffold
    return Scaffold(
      // FIX 3: Add SingleChildScrollView for keyboard safety
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formGlobalKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // FIX 2: Added Image Preview UI
                  // if (_image != null)
                  //   CircleAvatar(
                  //     radius: 50,
                  //     backgroundImage: FileImage(_image!),
                  //   )
                  // else
                  //   const CircleAvatar(
                  //     radius: 50,
                  //     child: Icon(Icons.person, size: 50),
                  //   ),
                  const SizedBox(height: 20),

                  //---NAME FIELD---
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Full Name:",
                      border: OutlineInputBorder(),
                    ),
                    // Safe validator order
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter your name"
                        : null,
                    // maxLength: 30,
                  ),
                  const SizedBox(height: 20),

                  //---EMAIL FIELD---
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || !value.contains('@') || value.isEmpty
                            ? 'Invalid email'
                            : null,
                  ),
                  const SizedBox(height: 20),

                  //----PHONE NUMBER-----
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.length < 10
                        ? "Enter valid number"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  //----PASSWORD -----
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.length < 6
                        ? "Minimum 6 characters"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  OutlinedButton(
                    onPressed: _pickImage, // Simplified syntax
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      foregroundColor: const Color(0xff646464),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add Profile Picture"),
                        Icon(Icons.photo, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  //----REGISTER BUTTON -----
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration Successful!"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff862c0c),
                      minimumSize: const Size(300, 45),
                    ),
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 20),

                  //Login Button
                  FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(300, 45)),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20),

                  //--- GOOGLE BUTTON ---
                  OutlinedButton(
                    // Function to: Implement Google Sign-In logic
                    onPressed: handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize:
                          const Size(300, 48), // Matching your other buttons
                      side: const BorderSide(
                          color: Color(0xFFE0E0E0)), // Light grey border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Logo (Using a network image for quick setup)
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Sign up with Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
