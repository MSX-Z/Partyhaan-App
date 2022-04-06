import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final Function(String value) validator;

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  late bool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = true;
  }

  void toggleFieldPassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      obscureText: isPasswordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          decoration: TextDecoration.none,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: '***********',
        prefixIcon: const Icon(
          Icons.lock,
        ),
        suffixIcon: GestureDetector(
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onTap: () {
            toggleFieldPassword();
          },
        ),
      ),
      validator: (String? value) {
        return widget.validator(value!);
      },
    );
  }
}
