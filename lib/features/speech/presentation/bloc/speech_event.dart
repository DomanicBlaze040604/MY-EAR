part of 'speech_bloc.dart';

abstract class SpeechEvent extends Equatable {
  const SpeechEvent();

  @override
  List<Object> get props => [];
}

class StartListening extends SpeechEvent {}

class StopListening extends SpeechEvent {}

class SpeakText extends SpeechEvent {
  final String text;
  const SpeakText(this.text);

  @override
  List<Object> get props => [text];
}

class ChangeLanguage extends SpeechEvent {
  final String language;
  const ChangeLanguage(this.language);

  @override
  List<Object> get props => [language];
}
