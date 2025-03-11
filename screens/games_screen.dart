import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: Center(
        child: Text(
          'Interactive games will be available here',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
