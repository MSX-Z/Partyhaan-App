import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.validator,
    this.labelText = '',
    this.hintText = '',
    this.iconData = Icons.message_rounded,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText, hintText;
  final IconData iconData; 
  final TextInputType keyboardType; 
  final Function(String value) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          decoration: TextDecoration.none,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: hintText,
        prefixIcon: Icon(iconData),
      ),
      validator: (String? value) {
        return validator(value!);
      },
    );
  }
}