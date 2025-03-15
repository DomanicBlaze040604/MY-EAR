import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/speech_record.dart';
import '../../domain/repositories/speech_repository.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechRepository repository;
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  String _currentLanguage = 'en-US';

  SpeechBloc(this.repository) : super(SpeechInitial()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<SpeakText>(_onSpeakText);
    on<ChangeLanguage>(_onChangeLanguage);
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      await _speech.initialize(
        onError: (error) => add(StopListening()),
        onStatus: (status) {
          if (status == 'done') {
            add(StopListening());
          }
        },
      );
      await _flutterTts.setLanguage(_currentLanguage);
    } catch (e) {
      emit(SpeechError('Failed to initialize speech: $e'));
    }
  }

  void _onStartListening(
    StartListening event,
    Emitter<SpeechState> emit,
  ) async {
    if (!_speech.isAvailable) {
      emit(const SpeechError('Speech recognition not available'));
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            emit(SpeechSuccess(result.recognizedWords, result.confidence));
            _saveRecord(result.recognizedWords, result.confidence);
          }
        },
        localeId: _currentLanguage,
      );
      emit(SpeechListening());
    } catch (e) {
      emit(SpeechError('Failed to start listening: $e'));
    }
  }

  void _onStopListening(StopListening event, Emitter<SpeechState> emit) async {
    await _speech.stop();
    emit(SpeechInitial());
  }

  void _onSpeakText(SpeakText event, Emitter<SpeechState> emit) async {
    try {
      await _flutterTts.speak(event.text);
    } catch (e) {
      emit(SpeechError('Failed to speak text: $e'));
    }
  }

  void _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SpeechState> emit,
  ) async {
    _currentLanguage = event.language;
    await _flutterTts.setLanguage(event.language);
    emit(SpeechInitial());
  }

  Future<void> _saveRecord(String text, double confidence) async {
    final record = SpeechRecord(
      id: DateTime.now().toIso8601String(),
      text: text,
      timestamp: DateTime.now(),
      confidence: confidence,
      language: _currentLanguage,
    );
    await repository.saveRecord(record);
  }

  @override
  Future<void> close() {
    _speech.stop();
    _flutterTts.stop();
    return super.close();
  }
}
