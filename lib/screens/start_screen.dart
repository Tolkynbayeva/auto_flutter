import 'package:flutter/widgets.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(context) {
    return Center(
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
    );
  }
}
