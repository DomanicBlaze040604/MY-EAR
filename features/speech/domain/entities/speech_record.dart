import 'package:equatable/equatable.dart';

class SpeechRecord extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final double confidence;
  final String language;

  const SpeechRecord({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.confidence,
    required this.language,
  });

  @override
  List<Object> get props => [id, text, timestamp, confidence, language];
}
