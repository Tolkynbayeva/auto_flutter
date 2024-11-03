import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text = "Добавить автомобиль",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          textStyle: AutoTextStyles.h3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
        ),
      ),
    );
  }
}
