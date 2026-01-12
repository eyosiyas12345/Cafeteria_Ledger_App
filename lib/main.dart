import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:helloworld/pages/app_shell/splash_screen.dart';
import 'package:helloworld/providers/menu_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenuProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Make MyApp constructor const
  @override
  Widget build(BuildContext context) {
    // Add a type to the context parameter
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Make SplashScreen const
    );
  }
}
