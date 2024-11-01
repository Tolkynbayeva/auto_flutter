import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/cars/add_cars_screen.dart';

class Auto extends StatefulWidget {
  const Auto({super.key});
  @override
  State<Auto> createState() => _AutoState();
}
class _AutoState extends State<Auto> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: AddCarsPage(),
        ),
      ),
    );
  }
}
