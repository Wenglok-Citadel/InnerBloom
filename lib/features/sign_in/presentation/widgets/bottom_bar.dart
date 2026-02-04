import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(this.title, this.subtitle, this.voidCallback, {super.key});

  final String title;

  final String subtitle;

  final VoidCallback voidCallback;

  static const Color _brandTeal = Color(0xFF7BAEA9);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: _brandTeal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
              GestureDetector(
                onTap: voidCallback,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFFD9D9D9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFD9D9D9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
