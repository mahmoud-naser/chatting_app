import 'package:flutter/material.dart';
import 'package:chat_app_new/src/core/resources/sizes.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: const Color(0xFF58889C),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF58889C),
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
    onPrimary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    titleSpacing: kDefaultPadding,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color(0xFF58889C),
    selectionHandleColor: Color(0xFF58889C),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all(const Color(0xFF58889C)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.white60),
  ),
);

