import 'package:flutter/material.dart';
import 'package:threads/utils/type_def.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final ValidatorCallBack validator;
  final TextEditingController controller;
  const AuthInput({
    super.key,
    required this.validator,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
