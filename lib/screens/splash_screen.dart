import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/cars/add_car_screen.dart';
import 'package:auto_flutter/screens/cars/my_cars_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAddCarPage();
  }

  void _navigateToAddCarPage() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (context) => const AddCarScreen()),
        MaterialPageRoute(builder: (context) => MyCarsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/pana.png',
              width: 350.0,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Храните информацию о ваших автомобилях прямо в телефоне',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
