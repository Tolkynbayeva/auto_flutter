import 'package:auto_flutter/models/roadside_model.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  final RoadsideSolution solution;

  const ArticleScreen({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Решения проблем на дороге',
          style: AutoTextStyles.h3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                solution.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              solution.title,
              style: AutoTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  solution.content,
                  style: AutoTextStyles.b1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
