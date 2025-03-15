part of 'speech_bloc.dart';

abstract class SpeechState extends Equatable {
  const SpeechState();

  @override
  List<Object> get props => [];
}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {}

class SpeechProcessing extends SpeechState {}

class SpeechError extends SpeechState {
  final String message;
  const SpeechError(this.message);

  @override
  List<Object> get props => [message];
}

class SpeechSuccess extends SpeechState {
  final String text;
  final double confidence;
  const SpeechSuccess(this.text, this.confidence);

  @override
  List<Object> get props => [text, confidence];
}
