import 'package:flutter/material.dart';
import '../constants/color_constants.dart';
import 'custom_card.dart';

class AccessibilityOptionsCard extends StatelessWidget {
  final bool isDarkMode;
  final bool isHighContrast;
  final bool isTextToSpeechEnabled;
  final double textScaleFactor;
  final Function(bool) onDarkModeChanged;
  final Function(bool) onHighContrastChanged;
  final Function(bool) onTextToSpeechChanged;
  final Function(double) onTextScaleFactorChanged;

  const AccessibilityOptionsCard({
    Key? key,
    required this.isDarkMode,
    required this.isHighContrast,
    required this.isTextToSpeechEnabled,
    required this.textScaleFactor,
    required this.onDarkModeChanged,
    required this.onHighContrastChanged,
    required this.onTextToSpeechChanged,
    required this.onTextScaleFactorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      semanticsLabel: 'Accessibility Options',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accessibility Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Dark Mode',
            'Enable dark mode for better visibility',
            isDarkMode,
            onDarkModeChanged,
          ),
          _buildSwitchTile(
            'High Contrast',
            'Increase contrast for better readability',
            isHighContrast,
            onHighContrastChanged,
          ),
          _buildSwitchTile(
            'Text to Speech',
            'Read text aloud automatically',
            isTextToSpeechEnabled,
            onTextToSpeechChanged,
          ),
          const SizedBox(height: 16),
          _buildTextScaleSlider(context),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Semantics(
      toggled: value,
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(description),
        value: value,
        onChanged: onChanged,
        activeColor: ColorConstants.primary,
      ),
    );
  }

  Widget _buildTextScaleSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Text Size'),
        Slider(
          value: textScaleFactor,
          min: 0.8,
          max: 2.0,
          divisions: 6,
          label: '${(textScaleFactor * 100).round()}%',
          onChanged: onTextScaleFactorChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('A', style: TextStyle(fontSize: 14)),
            Text('A', style: TextStyle(fontSize: 24)),
          ],
        ),
      ],
    );
  }
}
