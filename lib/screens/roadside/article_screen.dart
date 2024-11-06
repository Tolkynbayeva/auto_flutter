import 'package:auto_flutter/models/roadside_model.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  final RoadsideSolution solution;

  const ArticleScreen({Key? key, required this.solution}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_getUrl(widget.solution.url)));
  }

  String _getUrl(String url) {
    return url.startsWith('http') ? url : 'https://$url';
  }

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
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(16),
            //   child: Image.asset(
            //     widget.solution.imageUrl,
            //     height: 150,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Text(
            //   widget.solution.title,
            //   style: AutoTextStyles.h1,
            // ),
            // const SizedBox(height: 16),
            Expanded(
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}