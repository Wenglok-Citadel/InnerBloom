import 'package:flutter/material.dart';

class PlanHeaderOrb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F7F2), Color(0xFFFFF1D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.calendar_today_rounded,
          size: 56,
          color: Color(0xFF2F5C52),
        ),
      ),
    );
  }
}
