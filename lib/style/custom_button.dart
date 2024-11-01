import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';

class AddCarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AddCarButton({
    Key? key,
    required this.onPressed,
    this.text = "Добавить автомобиль",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          textStyle: AutoTextStyles.h3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}