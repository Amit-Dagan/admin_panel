import 'package:flutter/material.dart';

class BasicTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double size;
  final Color color;

  const BasicTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.size,
    this.color = Colors.white, // 👈 Default value here
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: size,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}
