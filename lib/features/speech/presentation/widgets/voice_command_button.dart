import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/speech_bloc.dart';

class VoiceCommandButton extends StatelessWidget {
  const VoiceCommandButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeechBloc, SpeechState>(
      builder: (context, state) {
        final bool isListening = state is SpeechListening;

        return FloatingActionButton(
          onPressed: () {
            if (isListening) {
              context.read<SpeechBloc>().add(StopListening());
            } else {
              context.read<SpeechBloc>().add(StartListening());
            }
          },
          backgroundColor:
              isListening ? Colors.red : Theme.of(context).primaryColor,
          child: Icon(isListening ? Icons.stop : Icons.mic),
        );
      },
    );
  }
}
