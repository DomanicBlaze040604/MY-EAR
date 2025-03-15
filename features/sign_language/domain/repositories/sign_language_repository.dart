import 'package:camera/camera.dart';
import '../entities/sign_detection.dart';

abstract class SignLanguageRepository {
  Future<void> initializeModel();
  Future<bool> isModelReady();
  Future<SignDetection?> processFrame(CameraImage image);
  Future<List<SignDetection>> getRecentDetections();
  Future<void> saveDetection(SignDetection detection);
  Future<void> clearDetections();
  Future<List<String>> getSupportedGestures();
  Future<void> startDetection(Function(SignDetection?) onDetection);
  Future<void> stopDetection();
  void dispose();
}
