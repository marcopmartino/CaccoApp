import 'package:flutter/material.dart';

class AppColors {
  static const Color mainShit = Color(0xFF474d22);
  static const Color heavyShit = Color(0xFF3C302C);
  static const Color softShit = Color (0xFF665A2C);
  static const Color problemShit = Color (0xFF82813d);
  static const Color bloodyShit = Color(0xFF4C1A1A);

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