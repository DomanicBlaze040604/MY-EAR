import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/speech_bloc.dart';
import '../widgets/voice_command_button.dart';

class SpeechToTextScreen extends StatelessWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<SpeechBloc, SpeechState>(
        listener: (context, state) {
          if (state is SpeechError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatusCard(state),
                const SizedBox(height: 20),
                _buildTranscriptionArea(state),
                const SizedBox(height: 20),
                _buildActionButtons(context, state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const VoiceCommandButton(),
    );
  }

  Widget _buildStatusCard(SpeechState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              state is SpeechListening ? 'Listening...' : 'Not listening',
              style: TextStyle(
                color: state is SpeechListening ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptionArea(SpeechState state) {
    String text = '';
    if (state is SpeechSuccess) {
      text = state.text;
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Text(
          text.isEmpty ? 'Start speaking...' : text,
          style: TextStyle(
            fontSize: 18,
            color: text.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, SpeechState state) {
    String text = '';
    if (state is SpeechSuccess) {
      text = state.text;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed:
              text.isEmpty
                  ? null
                  : () {
                    context.read<SpeechBloc>().add(SpeakText(text));
                  },
          icon: const Icon(Icons.volume_up),
          label: const Text('Play'),
        ),
        ElevatedButton.icon(
          onPressed:
              text.isEmpty
                  ? null
                  : () async {
                    await Clipboard.setData(ClipboardData(text: text));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Text copied to clipboard'),
                        ),
                      );
                    }
                  },
          icon: const Icon(Icons.copy),
          label: const Text('Copy'),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English (US)'),
                  onTap: () {
                    context.read<SpeechBloc>().add(
                      const ChangeLanguage('en-US'),
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Spanish'),
                  onTap: () {
                    context.read<SpeechBloc>().add(
                      const ChangeLanguage('es-ES'),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('How to use'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Tap the microphone button to start'),
                Text('2. Speak clearly into your device'),
                Text('3. The text will appear automatically'),
                Text('4. Use the buttons to:'),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Play the text'),
                      Text('• Copy to clipboard'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Got it'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
