import 'package:flutter/material.dart';

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Therapy')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _personalizedTraining,
              child: const Text('Personalized Training'),
            ),
            ElevatedButton(
              onPressed: _aiPoweredGuidance,
              child: const Text('AI-powered Guidance'),
            ),
          ],
        ),
      ),
    );
  }

  void _personalizedTraining() {
    // Implement personalized training feature
  }

  void _aiPoweredGuidance() {
    // Implement AI-powered guidance feature
  }
}
