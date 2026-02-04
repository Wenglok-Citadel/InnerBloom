import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget {
  const HeadlineText(this.text, {super.key});

  final String text;

  static const Color _brandTeal = Color(0xFF7BAEA9);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: _brandTeal,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    );
  }
}
