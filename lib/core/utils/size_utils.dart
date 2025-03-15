import 'package:flutter/material.dart';

class SizeUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  // Get proportionate height according to screen size
  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = SizeUtils.screenHeight;
    // 812 is the design layout height
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get proportionate width according to screen size
  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = SizeUtils.screenWidth;
    // 375 is the design layout width
    return (inputWidth / 375.0) * screenWidth;
  }
}
