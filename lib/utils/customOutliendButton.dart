import 'package:flutter/material.dart';

ButtonStyle customOutlinedButtonStyle() {
  return ButtonStyle(
      shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}
