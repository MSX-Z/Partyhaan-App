import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.title,
    required this.onPressed,
    this.enable = true
  }) : super(key: key);

  final String title;
  final Function() onPressed;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: (enable) ? onPressed : null,
        child: Text('$title'),
      ),
    );
  }
}
