import 'package:equatable/equatable.dart';

class SignDetection extends Equatable {
  final String id;
  final String gesture;
  final String translation;
  final double confidence;
  final DateTime timestamp;

  const SignDetection({
    required this.id,
    required this.gesture,
    required this.translation,
    required this.confidence,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, gesture, translation, confidence, timestamp];

  // Factory method to create from Map
  factory SignDetection.fromJson(Map<String, dynamic> json) {
    return SignDetection(
      id: json['id'] as String,
      gesture: json['gesture'] as String,
      translation: json['translation'] as String,
      confidence: json['confidence'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Convert to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gesture': gesture,
      'translation': translation,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
