import 'package:equatable/equatable.dart';

class SpeechRecognition extends Equatable {
  final String id;
  final String text;
  final double confidence;
  final DateTime timestamp;

  const SpeechRecognition({
    required this.id,
    required this.text,
    required this.confidence,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, text, confidence, timestamp];

  factory SpeechRecognition.fromJson(Map<String, dynamic> json) {
    return SpeechRecognition(
      id: json['id'],
      text: json['text'],
      confidence: json['confidence'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
