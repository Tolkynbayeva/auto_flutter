import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/models/roadside_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RoadsideScreen extends StatefulWidget {
  const RoadsideScreen({Key? key}) : super(key: key);

  @override
  _RoadsideScreenState createState() => _RoadsideScreenState();
}

class _RoadsideScreenState extends State<RoadsideScreen> {
  List<RoadsideSolution> solutions = [];

  @override
  void initState() {
    super.initState();
    _loadSolutions();
  }

  Future<void> _loadSolutions() async {
    final String response = await rootBundle.loadString('assets/roadside_solutions.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      solutions = data.map((json) => RoadsideSolution.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Решения проблем на дороге',
        subtitle: 'Мои автомобили',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: solutions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: solutions.map((solution) {
                    return Column(
                      children: [
                        _buildCard(solution),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Widget _buildCard(RoadsideSolution solution) {
    return GestureDetector(
      onTap: () {
        _launchURL(solution.url);
      },
      child: Stack(
        alignment: Alignment.bottomLeft,
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
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              solution.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку: $url')),
      );
    }
  }
}