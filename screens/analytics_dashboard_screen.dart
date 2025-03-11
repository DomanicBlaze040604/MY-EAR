import 'package:flutter/material.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: Center(
        child: Text(
          'Analytics data will be displayed here',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
