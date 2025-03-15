import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

class GamesScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const GamesScreen({super.key, required this.filePath, required this.title});

  Future<String> loadMarkdown(String filePath) async {
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder(
        future: loadMarkdown(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading content'));
          } else {
            return Markdown(data: snapshot.data ?? '');
          }
        },
      ),
    );
  }
}
