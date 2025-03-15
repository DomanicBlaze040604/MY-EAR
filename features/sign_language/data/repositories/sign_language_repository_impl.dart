import 'package:camera/camera.dart';
import '../../domain/repositories/sign_language_repository.dart';
import '../../domain/entities/sign_detection.dart';
import '../providers/model_provider.dart';
import '../providers/storage_provider.dart';
import '../providers/camera_provider.dart';
import '../providers/image_processor_provider.dart';

class SignLanguageRepositoryImpl implements SignLanguageRepository {
  final SignLanguageModelProvider _modelProvider;
  final SignLanguageStorageProvider _storageProvider;
  final SignLanguageCameraProvider _cameraProvider;
  final ImageProcessorProvider _imageProcessor;

  SignLanguageRepositoryImpl({
    required SignLanguageModelProvider modelProvider,
    required SignLanguageStorageProvider storageProvider,
    required SignLanguageCameraProvider cameraProvider,
    required ImageProcessorProvider imageProcessor,
  }) : _modelProvider = modelProvider,
       _storageProvider = storageProvider,
       _cameraProvider = cameraProvider,
       _imageProcessor = imageProcessor;

  @override
  Future<void> initializeModel() async {
    await _modelProvider.loadModel();
    await _cameraProvider.initialize();
  }

  @override
  Future<bool> isModelReady() async {
    return _modelProvider.isModelLoaded && _cameraProvider.isInitialized;
  }

  @override
  Future<SignDetection?> processFrame(CameraImage image) async {
    if (!await isModelReady()) {
      throw Exception('Model or camera not initialized');
    }

    try {
      // Process image
      final processedImage = await _imageProcessor.processImage(image);

      // Prepare output tensor
      final output = List<double>.filled(
        _modelProvider.labels.length,
        0,
      ).reshape([1, _modelProvider.labels.length]);

      // Run inference
      _modelProvider.interpreter!.run(processedImage, output);

      // Get highest confidence prediction
      int maxIndex = 0;
      double maxValue = output[0][0];

      for (int i = 1; i < _modelProvider.labels.length; i++) {
        if (output[0][i] > maxValue) {
          maxIndex = i;
          maxValue = output[0][i];
        }
      }

      // Create detection if confidence is high enough
      if (maxValue > 0.7) {
        final detection = SignDetection(
          id: DateTime.now().toIso8601String(),
          gesture: _modelProvider.labels[maxIndex],
          translation: _modelProvider.labels[maxIndex],
          confidence: maxValue,
          timestamp: DateTime.now(),
        );

        await _storageProvider.saveDetection(detection);
        return detection;
      }
    } catch (e) {
      print('Error processing frame: $e');
    }
    return null;
  }

  @override
  Future<List<SignDetection>> getRecentDetections() async {
    return _storageProvider.getStoredDetections();
  }

  @override
  Future<void> saveDetection(SignDetection detection) async {
    await _storageProvider.saveDetection(detection);
  }

  @override
  Future<void> clearDetections() async {
    await _storageProvider.clearDetections();
  }

  @override
  Future<List<String>> getSupportedGestures() async {
    return _modelProvider.labels;
  }

  @override
  Future<void> startDetection(Function(SignDetection?) onDetection) async {
    await _cameraProvider.startImageStream((image) async {
      final detection = await processFrame(image);
      onDetection(detection);
    });
  }

  @override
  Future<void> stopDetection() async {
    await _cameraProvider.stopImageStream();
  }

  @override
  void dispose() {
    _modelProvider.dispose();
    _cameraProvider.dispose();
  }
}
