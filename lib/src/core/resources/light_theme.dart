import 'package:flutter/material.dart';
import 'package:chat_app_new/src/core/resources/sizes.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0xFF58889C),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF58889C),
    surface: Colors.white,
    onSurface: Colors.black,
    onPrimary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleSpacing: kDefaultPadding,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.black),
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
    color: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: Colors.black54),
  ),
);

