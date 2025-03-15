import 'package:shared_preferences/shared_preferences.dart';
import '../providers/model_provider.dart';
import '../providers/storage_provider.dart';
import '../providers/camera_provider.dart';
import '../providers/image_processor_provider.dart';
import '../repositories/sign_language_repository_impl.dart';
import '../../domain/repositories/sign_language_repository.dart';

class SignLanguageRepositoryFactory {
  static Future<SignLanguageRepository> create() async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Create all providers
    final modelProvider = SignLanguageModelProvider();
    final storageProvider = SignLanguageStorageProvider(prefs);
    final cameraProvider = SignLanguageCameraProvider();
    final imageProcessor = ImageProcessorProvider();

    // Create and return repository implementation with all dependencies
    return SignLanguageRepositoryImpl(
      modelProvider: modelProvider,
      storageProvider: storageProvider,
      cameraProvider: cameraProvider,
      imageProcessor: imageProcessor,
    );
  }

  static Future<SignLanguageRepository> createWithMocks({
    SignLanguageModelProvider? mockModelProvider,
    SignLanguageStorageProvider? mockStorageProvider,
    SignLanguageCameraProvider? mockCameraProvider,
    ImageProcessorProvider? mockImageProcessor,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    return SignLanguageRepositoryImpl(
      modelProvider: mockModelProvider ?? SignLanguageModelProvider(),
      storageProvider:
          mockStorageProvider ?? SignLanguageStorageProvider(prefs),
      cameraProvider: mockCameraProvider ?? SignLanguageCameraProvider(),
      imageProcessor: mockImageProcessor ?? ImageProcessorProvider(),
    );
  }
}
