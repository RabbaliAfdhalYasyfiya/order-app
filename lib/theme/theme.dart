import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.white,
  shadowColor: Colors.black54,
  primaryColor: Colors.deepPurpleAccent.shade400,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.deepPurpleAccent.shade400,
    onPrimary: Colors.deepPurpleAccent.shade200,
    secondary: Colors.greenAccent.shade700,
    onSecondary: Colors.greenAccent,
    error: Colors.redAccent.shade400,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface: Colors.grey.shade100,
    outline: Colors.black26,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent.shade400,
    elevation: 2,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.deepPurple.shade50.withValues(alpha: 0.25),
    indicatorColor: Colors.deepPurple.shade50,
    overlayColor: WidgetStatePropertyAll(Colors.deepPurple.shade100),
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(
        color: Colors.deepPurpleAccent.shade400,
        applyTextScaling: true,
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade50.withValues(alpha: 0.25),
    iconTheme: IconThemeData(
      color: Colors.deepPurpleAccent.shade400,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    dense: false,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    visualDensity: VisualDensity.comfortable,
    titleAlignment: ListTileTitleAlignment.center,
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    ),
  ),
);
