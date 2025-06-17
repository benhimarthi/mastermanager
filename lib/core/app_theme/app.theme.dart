import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(68, 137, 255, 0),
      foregroundColor: Color.fromARGB(255, 0, 0, 0),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(500, 50),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(198, 255, 255, 255),
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 10),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 245, 87, 84),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        labelStyle: TextStyle(color: Color.fromARGB(255, 146, 146, 146)),
        filled: true,
        fillColor: Color.fromARGB(162, 239, 246, 255),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: TextStyle(color: Color.fromARGB(198, 110, 110, 110))),
  );
}
