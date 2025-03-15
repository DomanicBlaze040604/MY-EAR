import 'package:flutter/material.dart';

class HighContrastText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isHighContrast;

  const HighContrastText(
    this.text, {
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isHighContrast = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    Color getTextColor() {
      if (!isHighContrast) {
        return isLightMode ? Colors.black : Colors.white;
      }
      return isLightMode ? Colors.black : Colors.white;
    }

    Color getBackgroundColor() {
      if (!isHighContrast) {
        return Colors.transparent;
      }
      return isLightMode ? Colors.white : Colors.black;
    }

    return Semantics(
      label: text,
      child: Container(
        padding:
            isHighContrast ? const EdgeInsets.symmetric(horizontal: 4) : null,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: isHighContrast ? BorderRadius.circular(4) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: getTextColor(),
            height: 1.2,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}
