import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key, required this.onTapCallback});

  static const Color _brandTeal = Color(0xFF7BAEA9);

  final GestureTapCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: onTapCallback,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close, color: _brandTeal),
        ),
      ),
    );
  }
}
