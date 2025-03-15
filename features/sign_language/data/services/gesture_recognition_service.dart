import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../providers/image_processor_provider.dart';
import '../../domain/entities/sign_detection.dart';

class GestureRecognitionService {
  final ImageProcessorProvider _imageProcessor;
  final Interpreter _interpreter;
  final List<String> _labels;

  GestureRecognitionService({
    required ImageProcessorProvider imageProcessor,
    required Interpreter interpreter,
    required List<String> labels,
  }) : _imageProcessor = imageProcessor,
       _interpreter = interpreter,
       _labels = labels;

  Future<SignDetection?> processImage(CameraImage image) async {
    try {
      final processedImage = await _imageProcessor.processImage(image);

      final output = List<double>.filled(
        _labels.length,
        0,
      ).reshape([1, _labels.length]);

      _interpreter.run(processedImage, output);

      int maxIndex = 0;
      double maxValue = output[0][0];

      for (int i = 1; i < _labels.length; i++) {
        if (output[0][i] > maxValue) {
          maxIndex = i;
          maxValue = output[0][i];
        }
      }

      if (maxValue > 0.7) {
        return SignDetection(
          id: DateTime.now().toIso8601String(),
          gesture: _labels[maxIndex],
          translation: _labels[maxIndex],
          confidence: maxValue,
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error processing image: $e');
    }
    return null;
  }

  List<String> getSupportedGestures() => List.unmodifiable(_labels);
}
