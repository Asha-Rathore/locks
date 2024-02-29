import 'package:flutter/material.dart';

class AppColors {
  static const Color THEME_COLOR_TRANSPARENT = Colors.transparent;
  static const Color PRIMARY_COLOR = Color(0xff024023);
  static const Color LIGHT_PRIMARY_COLOR = Color(0xff06F628);
  static const Color THEME_COLOR_WHITE = Color(0xffFFFFFF);
  static const Color THEME_COLOR_BLACK = Color(0xff000000);
  static const Color THEME_COLOR_GOOGLE = Color(0xffCF2C1F);
  static const Color THEME_COLOR_LIGHT_GREEN = Color(0xff00FC24);
  static const Color THEME_COLOR_DARK_GREEN = Color(0xff032716);
  static const Color THEME_COLOR_GRAPH_BORDER = Color(0xff1A744A);
  static Color SHIMMER_HIGHLIGHT_COLOR = Colors.grey;
  static Color SHIMMER_BASE_COLOR = Colors.grey.withOpacity(0.8);
  // static Color SHIMMER_HIGHLIGHT_COLOR = Colors.white.withOpacity(0.2);
  // static Color SHIMMER_BASE_COLOR = Colors.black.withOpacity(0.1);

  static MaterialColor kPrimaryColor = const MaterialColor(
    0xff024023,
    <int, Color>{
      50: Color(0xff024023),
      100: Color(0xff024023),
      200: Color(0xff024023),
      300: Color(0xff024023),
      400: Color(0xff024023),
      500: Color(0xff024023),
      600: Color(0xff024023),
      700: Color(0xff024023),
      800: Color(0xff024023),
      900: Color(0xff024023),
    },
  );


  static MaterialColor textFieldThemeColor =  MaterialColor(
    0xffffffff,
    <int, Color>{
      50: Colors.white,
      100: Colors.white,
      200: Colors.white,
      300: Colors.white,
      400: Colors.white,
      500: Colors.white,
      600: Colors.white,
      700: Colors.white,
      800: Colors.white,
      900: Colors.white,
    },
  );
}
