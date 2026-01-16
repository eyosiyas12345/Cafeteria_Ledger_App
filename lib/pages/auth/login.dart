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

  // --- Logic: ACTUAL Google Login Function ---
  // Future<void> _loginWithGoogle() async {
  //   try {
  //     // 1. Trigger the Google Authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     // 2. Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     if (googleAuth == null) return; // User canceled

  //     // 3. Create a new credential for Firebase
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // 4. Once signed in, return the UserCredential and navigate
  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     if (mounted) {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const MainScreen()));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Google Sign-In Error: $e")));
  //   }
  // }
  Future<void> _loginWithGoogle() async {
    try {
      // Logic: Initialize the Google Sign In object
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 1. Start the flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // User closed the popup

      // 2. Get the auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create the credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Google Error: $e")));
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
                const Text("Welcome Back",
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

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Logic: Actual Firebase Auth
// import 'package:helloworld/pages/auth/singup.dart';
// import 'package:helloworld/constants/app_colors.dart';
// import 'package:helloworld/main_screen.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formGlobalKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   // --- Logic: Email/Password Login ---
//   Future<void> _loginWithEmail() async {
//     if (_formGlobalKey.currentState!.validate()) {
//       try {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//         if (mounted) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => const MainScreen()));
//         }
//       } on FirebaseAuthException catch (e) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed")));
//       }
//     }
//   }

//   // --- Logic: Google Login (Returning or New) ---
//   // Note: This requires the google_sign_in package
//   Future<void> _loginWithGoogle() async {
//     // This is where your Google Sign In logic goes.
//     // Firebase handles checking if the user is new or returning automatically!
//     print("Trigger Google Auth Flow...");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Form(
//             key: _formGlobalKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text("Welcome Back",
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: primaryColor)),
//                 const SizedBox(height: 30),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                       labelText: "Email:", border: OutlineInputBorder()),
//                   validator: (value) => value!.isEmpty || !value.contains("@")
//                       ? "Invalid email"
//                       : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                       labelText: "Password", border: OutlineInputBorder()),
//                   validator: (value) => value!.isEmpty || value.length < 8
//                       ? "Incorrect password"
//                       : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // Login Button
//                 FilledButton(
//                   onPressed: _loginWithEmail,
//                   style: FilledButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       minimumSize: const Size(double.infinity, 50)),
//                   child: const Text("Login"),
//                 ),

//                 const SizedBox(height: 20),
//                 const Text("OR", style: TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 20),

//                 // --- NEW: Google Login Button ---
//                 OutlinedButton.icon(
//                   onPressed: _loginWithGoogle,
//                   icon: const Icon(Icons.login,
//                       color:
//                           primaryColor), // Use a Google icon if you have assets
//                   label: const Text("Continue with Google"),
//                   style: OutlinedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50)),
//                 ),

//                 const SizedBox(height: 40),
//                 TextButton(
//                   onPressed: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => SignUpPage())),
//                   child: const Text("Don't have an account? Create one"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
