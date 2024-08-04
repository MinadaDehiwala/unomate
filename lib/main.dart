import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
import 'package:flutter/material.dart';
import 'package:app/screens/welcome.dart'; // Adjust the import path according to your project structure

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnoMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(), // Set WelcomeScreen as the home screen
    );
  }
}
