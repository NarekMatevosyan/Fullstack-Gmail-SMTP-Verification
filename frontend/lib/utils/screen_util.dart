import 'package:flutter/material.dart';

class ScreenUtil {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    _screenWidth = mediaQueryData.size.width;
    _screenHeight = mediaQueryData.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;
  }

  static double verticalScale(double inputHeight) {
    return _blockSizeVertical * inputHeight;
  }

  static double horizontalScale(double inputWidth) {
    return _blockSizeHorizontal * inputWidth;
  }
}
