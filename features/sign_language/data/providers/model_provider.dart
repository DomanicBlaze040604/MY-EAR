import 'package:tflite_flutter/tflite_flutter.dart';

class SignLanguageModelProvider {
  static const String _modelPath = 'assets/models/sign_language_model.tflite';
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      _labels = [
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
        'SPACE',
        'DELETE',
      ];
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  bool get isModelLoaded => _interpreter != null;
  List<String> get labels => _labels ?? [];
  Interpreter? get interpreter => _interpreter;

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
