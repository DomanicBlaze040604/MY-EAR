import 'package:flutter/material.dart';
import 'screens/lectures_screen.dart';
import 'screens/games_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY-EAR',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/sign-language/lectures':
            (context) => LectureScreen(
              filePath: 'content/sign-language/lectures.md',
              title: 'Sign Language Lectures',
            ),
        '/sign-language/games':
            (context) => GamesScreen(
              filePath: 'content/sign-language/games.md',
              title: 'Sign Language Games',
            ),
        '/cochlear-implant/lectures':
            (context) => LectureScreen(
              filePath: 'content/cochlear-implant/lectures.md',
              title: 'Cochlear Implant Lectures',
            ),
        '/cochlear-implant/games':
            (context) => GamesScreen(
              filePath: 'content/cochlear-implant/games.md',
              title: 'Cochlear Implant Games',
            ),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MY-EAR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-language/lectures');
              },
              child: const Text('Sign Language Lectures'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-language/games');
              },
              child: const Text('Sign Language Games'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cochlear-implant/lectures');
              },
              child: const Text('Cochlear Implant Lectures'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cochlear-implant/games');
              },
              child: const Text('Cochlear Implant Games'),
            ),
          ],
        ),
      ),
    );
  }
}
