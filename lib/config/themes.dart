import 'package:iboxnav/core/utils/utility.dart';
import 'package:flutter/material.dart';

class Themes {
  Color lightBgColor = Utility.getFromHex("#F8F8F8");
  Color lightPrimaryColor = Utility.getFromHex("#0F91E7");
  static ThemeData _base = ThemeData(
      fontFamily: "Nunito",
      scaffoldBackgroundColor: _baseTheme.lightBgColor,
      hintColor: Color(0xFF707072));
  static ThemeData lightTheme = _base.copyWith(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light().copyWith(
        primary: _baseTheme.lightPrimaryColor,
        secondary: _baseTheme.lightPrimaryColor,
      ));
}

Themes _baseTheme = Themes();
