import 'package:flutter/material.dart';
import 'package:inner_bloom_app/features/boost_motivation/models/motivation_type.dart';
import 'package:inner_bloom_app/features/boost_motivation/presentation/pages/movitation_result_page.dart';

class BoostMotivationPage extends StatefulWidget {
  const BoostMotivationPage({super.key});

  @override
  State<BoostMotivationPage> createState() => _BoostMotivationPageState();
}

class _BoostMotivationPageState extends State<BoostMotivationPage> {
  String? _selectedType;

  final List<MotivationType> _types = const [
    MotivationType(keyName: 'quick', label: 'Quick Boost', emoji: '🔥'),
    MotivationType(keyName: 'focus', label: 'Focus Reset', emoji: '🎯'),
    MotivationType(keyName: 'energy', label: 'Energy Lift', emoji: '⚡'),
    MotivationType(
      keyName: 'encourage',
      label: 'Encouraging Words',
      emoji: '💬',
    ),
  ];

  void _startBoost() {
    if (_selectedType == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MotivationResultPage(motivationType: _selectedType!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Boost Motivation',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F5C52),
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Color(0xFF2F5C52)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // 🌟 Header
            const Icon(Icons.auto_awesome, size: 72, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              "You've got this 💪",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Let’s give you a little push forward.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 32),

            // 🎯 Motivation Types
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _types.map((type) {
                final bool isSelected = _selectedType == type.keyName;
                return ChoiceChip(
                  label: Text('${type.emoji} ${type.label}'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = type.keyName;
                    });
                  },
                  selectedColor: Colors.teal.shade100,
                );
              }).toList(),
            ),

            const Spacer(),

            // ▶ Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedType == null ? null : _startBoost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Start Boost',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
