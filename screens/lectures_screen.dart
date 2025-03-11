import 'package:flutter/material.dart';

class LecturesScreen extends StatelessWidget {
  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lectures')),
      body: Center(
        child: Text(
          'Lecture content will be displayed here',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
