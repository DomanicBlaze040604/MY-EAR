import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionProvider {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        debugLogging: true,
      );
    }
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required String selectedLocale,
  }) async {
    if (!_isInitialized) await initialize();

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: selectedLocale,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;
}
