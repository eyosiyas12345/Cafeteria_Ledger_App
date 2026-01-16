import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // for data model flexiblity and usability
import 'package:chapa_unofficial/chapa_unofficial.dart'; //for chapa
import 'package:helloworld/pages/app_shell/splash_screen.dart';
import 'package:helloworld/providers/menu_provider.dart';
// imports for firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Prepares Flutter for async code
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Logic: Tell the app to use your Chapa Test Key
  Chapa.configure(privateKey: 'CHAPUBK_TEST-pHha9wFE2e7XVAsPbqzjTqh0o5uVgK0o');

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
      home: const SplashScreen(),
    );
  }
}
