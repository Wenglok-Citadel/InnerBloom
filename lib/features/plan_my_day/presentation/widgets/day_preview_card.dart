import 'package:flutter/material.dart';
import 'package:inner_bloom_app/features/plan_my_day/presentation/widgets/plan_row.dart';

class DayPreviewCard extends StatelessWidget {
  final String intention;

  const DayPreviewCard({required this.intention});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(intention),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Your Day at a Glance",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          PlanRow(
            icon: Icons.wb_sunny_outlined,
            title: "Morning",
            desc: "Gentle start & breathing",
          ),
          PlanRow(
            icon: Icons.flash_on_outlined,
            title: "Midday",
            desc: "Focused work session",
          ),
          PlanRow(
            icon: Icons.directions_walk,
            title: "Afternoon",
            desc: "Mindful movement",
          ),
          PlanRow(
            icon: Icons.nightlight_round,
            title: "Evening",
            desc: "Wind down & reflect",
          ),
        ],
      ),
    );
  }
}
