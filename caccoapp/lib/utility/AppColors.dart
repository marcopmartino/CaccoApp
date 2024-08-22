import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBrown = Color(0xFF5F3a2B);
  static const Color softBrown = Color(0xFF7E5642);
  static const Color liquidBrown = Color(0xFF7A4D33);
  static const Color strongBrown = Color(0xFF60311A);
  static const Color problemBrown = Color (0xFF82813d);
  static const Color bloodyBrown = Color(0xFF4C1A1A);
  static const Color heavyBrown = Color(0xFF572815);
  static const Color sandBrown = Color(0xFFFAEADE);
  static const Color darkSandBrown = Color(0xFFF1D7C3);
  static const Color caramelBrown = Color(0xFFD19266);
  static const Color transparentCaramelBrown = Color(0x66D19266);
  static const Color tawnyBrown = Color(0xFFC37F4F);
  static const Color grayBrown = Color(0xFFDAC1AF);
  static const Color transparentGrayBrown = Color(0x66DAC1AF);

  static MaterialColor getMaterialColor(Color color){
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int,Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(color.value, shades);
  }
}