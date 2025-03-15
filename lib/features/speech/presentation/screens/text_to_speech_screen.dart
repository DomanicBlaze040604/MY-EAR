import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String _text = "";

  void _speak() async {
    await _flutterTts.speak(_text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text to Speech')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  _text = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter text to speak',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _speak, child: const Text('Speak')),
          ],
        ),
      ),
    );
  }
}
