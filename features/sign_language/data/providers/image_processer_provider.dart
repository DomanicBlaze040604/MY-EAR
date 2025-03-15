import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ImageProcessorProvider {
  static const int inputSize = 224;

  Future<List<double>> processImage(CameraImage image) async {
    try {
      final bytes = _convertYUV420toRGB(image);
      final input = Float32List(inputSize * inputSize);
      int pixel = 0;

      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final i = (y * image.width + x) * 3;
          final r = bytes[i];
          final g = bytes[i + 1];
          final b = bytes[i + 2];
          input[pixel++] = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
        }
      }

      return input.toList();
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  Uint8List _convertYUV420toRGB(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final output = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      int outputOffset = y * width * 3;

      for (int x = 0; x < width; x++) {
        final int uvOffset = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final yValue = image.planes[0].bytes[y * width + x];
        final uValue = image.planes[1].bytes[uvOffset];
        final vValue = image.planes[2].bytes[uvOffset];

        output[outputOffset++] = _clamp(
          (yValue + 1.402 * (vValue - 128)).toInt(),
        );
        output[outputOffset++] = _clamp(
          (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
              .toInt(),
        );
        output[outputOffset++] = _clamp(
          (yValue + 1.772 * (uValue - 128)).toInt(),
        );
      }
    }

    return output;
  }

  int _clamp(int value) {
    return value.clamp(0, 255);
  }
}
