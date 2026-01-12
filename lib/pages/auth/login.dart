// import 'package:flutter/material.dart';
// import 'package:helloworld/pages/app_shell/home_page.dart';

// class Login extends StatefulWidget {
//   Login({super.key});

//   @override
//   State<Login> createState() {
//     return _LoginState();
//   }
// }

// class _LoginState extends State<Login> {
//   @override
//   Widget build(context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//             child: Form(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   //---- USER NAME -----
//                   TextFormField(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Username",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   // ----PASSWORD ------
//                   TextFormField(
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Password",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),

//                   // ----LOGIN BUTTON ------
//                   FilledButton(
//                     onPressed: () => Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomePage(),
//                       ),
//                     ),
//                     child: Text("Login"),
//                     style: FilledButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),);
//   }
// }

import 'package:flutter/material.dart';
import 'package:helloworld/pages/app_shell/home_page.dart';
import 'package:helloworld/pages/auth/singup.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/main_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formGlobalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Email:"),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty || !value!.contains("@")
                    ? "Invalid email"
                    : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty || value.length < 8
                      ? "Incorrect password"
                      : null),
              SizedBox(
                height: 20,
              ),
              //Login Button
              FilledButton(
                onPressed: () {
                  if (_formGlobalKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Succefully logged in")),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  }
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: FilledButton.styleFrom(
                    backgroundColor: primaryColor, minimumSize: Size(300, 40)),
              ),
              SizedBox(height: 40),
              //Create account
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text("Create New Account",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  minimumSize: Size(150, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
