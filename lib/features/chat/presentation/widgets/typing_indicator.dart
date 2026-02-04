import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: const [
          Text("InnerBloom is typing", style: TextStyle(fontSize: 12)),
          SizedBox(width: 6),
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }
}
