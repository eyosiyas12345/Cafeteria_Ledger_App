import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cafeteria Ledger App",
      // themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: Color(0xff000000),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', width: 300),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Cafeteria Ledger",
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  color: Color(0xffffa905),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text(
                  "Register",
                ),
                icon: const Icon(
                  Icons.arrow_right_alt_rounded,
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xff53200d),
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
