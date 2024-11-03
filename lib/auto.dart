import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/splash_screen.dart';

class Auto extends StatelessWidget {
  const Auto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Flutter',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}