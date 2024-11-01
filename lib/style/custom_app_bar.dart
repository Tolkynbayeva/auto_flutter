import 'package:flutter/material.dart';
import 'text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, 
      title: Text(
        title,
        style: AutoTextStyles.h1,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.lightbulb,
            color: Colors.grey,
          ),
          onPressed: () {
            // Add theme switching logic if needed
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.grey,
          ),
          onPressed: () {
            // Navigate to settings page logic
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}