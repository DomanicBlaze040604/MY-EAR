import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class VoiceCommandButton extends StatefulWidget {
  final Function(String) onCommandReceived;
  final String? buttonLabel;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const VoiceCommandButton({
    Key? key,
    required this.onCommandReceived,
    this.buttonLabel,
    this.size = 56.0,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _animationController.repeat();
        // Start voice recognition here
        // For now, we'll simulate with a delayed response
        Future.delayed(const Duration(seconds: 3), () {
          widget.onCommandReceived("Sample voice command");
          _stopListening();
        });
      } else {
        _stopListening();
      }
    });
  }

  void _stopListening() {
    setState(() {
      isListening = false;
      _animationController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.buttonLabel ?? 'Voice Command Button',
      enabled: true,
      child: Material(
        elevation: 4,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _toggleListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening
                  ? ColorConstants.error
                  : (widget.backgroundColor ?? ColorConstants.primary),
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isListening
                        ? 1.0 + (_animationController.value * 0.2)
                        : 1.0,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: widget.iconColor ?? Colors.white,
                      size: widget.size * 0.5,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
