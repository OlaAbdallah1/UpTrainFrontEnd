import 'package:flutter/material.dart';
import 'package:uptrain/src/utils/theme/widget_themes/text_theme.dart';

class TappTheme {

  const TappTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, 
    textTheme: TTextTheme.lightTextTheme,
    // elevatedButtonTheme: TextButtonTheme.)
  );
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark, textTheme: TTextTheme.darkTextTheme);

}
