import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0.0,
    surfaceTintColor: Colors.black,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    brightness: Brightness.dark,
    onSurface: Colors.white,
    surfaceTint: Colors.black12,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    height: 50,
    iconTheme: WidgetStateProperty.all(IconThemeData(
      color: Colors.white,
      size: 30,
    )),
    indicatorColor: Colors.transparent,
  ),
);
