import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../entities/speech_session.dart';
import '../../../core/error/custom_exceptions.dart';

class SpeechRepository {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => throw SpeechRecognitionException(error.errorMsg),
        onStatus: (status) => print('Speech status: $status'),
      );

      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.8);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    }

    if (!_isInitialized) {
      throw SpeechRecognitionException(
        'Failed to initialize speech recognition services',
      );
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    String selectedLocale = "en-US",
  }) async {
    if (!_isInitialized) await initialize();

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: selectedLocale,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: false,
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> speakText(String text) async {
    if (!_isInitialized) await initialize();

    await _flutterTts.speak(text);
  }

  Future<void> pauseSpeaking() async {
    await _flutterTts.pause();
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  bool get isListening => _speechToText.isListening;
  bool get isInitialized => _isInitialized;

  List<String> getAvailableLanguages() {
    return _speechToText.locales.map((locale) => locale.localeId).toList();
  }
}

class SpeechRecognitionException implements Exception {
  final String message;
  SpeechRecognitionException(this.message);
  @override
  String toString() => 'SpeechRecognitionException: $message';
}
