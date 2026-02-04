import 'dart:math';

import 'package:flutter/material.dart';

class MotivationResultPage extends StatelessWidget {
  final String motivationType;

  const MotivationResultPage({super.key, required this.motivationType});

  static final Map<String, List<String>> _messages = {
    'quick': [
      "You’re doing better than you think.",
      "Small steps still move you forward.",
    ],
    'focus': [
      "Just 10 minutes. Start there.",
      "Clarity comes from action, not thinking.",
    ],
    'energy': [
      "Stand up. Breathe. You’ve got this.",
      "Your energy follows your movement.",
    ],
    'encourage': [
      "You don’t have to do this perfectly.",
      "I believe in you — even on hard days.",
    ],
  };

  String _getRandomMessage() {
    final list = _messages[motivationType] ?? [];
    return list[Random().nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    final message = _getRandomMessage();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Boost'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌈 Animated Feel
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.teal.shade200, Colors.teal.shade50],
                ),
              ),
              child: const Center(
                child: Icon(Icons.flash_on, size: 64, color: Colors.teal),
              ),
            ),

            const SizedBox(height: 32),

            // 💬 Message Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Say this to yourself:',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '“I am moving forward, one step at a time.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 🔘 Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Another Boost'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved to your motivation list 💛'),
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
