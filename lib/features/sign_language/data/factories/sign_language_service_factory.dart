import '../services/translation_service.dart';
import '../services/gesture_recognition_service.dart';

class SignLanguageServiceFactory {
  static Future<TranslationService> createTranslationService() async {
    return TranslationService();
  }

  static Future<GestureRecognitionService>
  createGestureRecognitionService() async {
    return GestureRecognitionService();
  }
}
