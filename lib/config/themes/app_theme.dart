import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(64, 3, 136, 1);
const onPrimaryColor = Colors.white;
const secondaryColor = Color.fromRGBO(206, 181, 252, 1);
const onSecondaryColor = Colors.white;
const tertiaryColor = Color.fromRGBO(237, 199, 219, 1);
const onTertiaryColor = Color.fromRGBO(64, 3, 136, 1);
const shadowColor = Color.fromRGBO(220, 203, 245, 0.70);
const backgroundColor = Colors.white;
const onBackgroundColor = Colors.black;
const errorColor = Colors.redAccent;
const onErrorColor = Colors.white;
const surfaceColor = Color.fromRGBO(234, 234, 234, 1);
const onSurfaceColor = Colors.white;

const timerGradient1 = Color.fromRGBO(207, 216, 255, 1);
const timerGradient2 = Color.fromRGBO(217, 203, 242, 1);
const timerGradient3 = Color.fromRGBO(201, 234, 235, 1);

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'URWGothic',
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          background: backgroundColor,
          onBackground: onBackgroundColor,
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          secondary: secondaryColor,
          onSecondary: onSecondaryColor,
          tertiary: tertiaryColor,
          onTertiary: onTertiaryColor,
          error: errorColor,
          onError: onErrorColor,
          surface: surfaceColor,
          onSurface: onSurfaceColor),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 24),
        displayMedium: TextStyle(fontSize: 16),
        displaySmall: TextStyle(fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: onSecondaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: backgroundColor,
        elevation: 2,
        shadowColor: shadowColor,
        titleTextStyle: TextStyle(
            fontFamily: 'BebasKai', fontSize: 24, color: onBackgroundColor),
      ),
    );
  }
}
