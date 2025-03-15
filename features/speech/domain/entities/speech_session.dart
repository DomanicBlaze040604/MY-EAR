import 'package:equatable/equatable.dart';

class SpeechSession extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final double confidence;
  final String language;
  final SpeechMode mode;
  final bool isCompleted;
  final Duration duration;

  const SpeechSession({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.confidence,
    required this.language,
    required this.mode,
    required this.isCompleted,
    required this.duration,
  });

  @override
  List<Object> get props => [
    id,
    text,
    timestamp,
    confidence,
    language,
    mode,
    isCompleted,
    duration,
  ];

  factory SpeechSession.fromJson(Map<String, dynamic> json) {
    return SpeechSession(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      confidence: json['confidence'],
      language: json['language'],
      mode: SpeechMode.values.firstWhere(
        (e) => e.toString() == 'SpeechMode.${json['mode']}',
      ),
      isCompleted: json['isCompleted'],
      duration: Duration(milliseconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
      'language': language,
      'mode': mode.toString().split('.').last,
      'isCompleted': isCompleted,
      'duration': duration.inMilliseconds,
    };
  }
}

enum SpeechMode { speechToText, textToSpeech }
