import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String value) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: "อีเมล",
        labelStyle: TextStyle(
          decoration: TextDecoration.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: 'example@gmail.com',
        prefixIcon: Icon(
          Icons.email,
        ),
      ),
      validator: (String? value) {
        return validator(value!);
      },
    );
  }
}