import 'package:flutter/material.dart';

class QuickReplyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const QuickReplyChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: const Color(0xFFE8F7F2),
      labelStyle: const TextStyle(fontSize: 13),
      elevation: 2,
    );
  }
}
