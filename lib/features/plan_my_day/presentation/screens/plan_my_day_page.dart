import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class PlanMyDayPage extends StatefulWidget {
  const PlanMyDayPage({super.key});

  @override
  State<PlanMyDayPage> createState() => _PlanMyDayPageState();
}

class _PlanMyDayPageState extends State<PlanMyDayPage> {
  String? _selectedIntention;

  static const Color primary = Color(0xFF2F5C52);
  static const Color accent = Color(0xFF91B6A9);
  static const Color bg = Colors.white;

  final List<String> intentions = const [
    '🌿 Balance',
    '⚡ Energy',
    '🧠 Focus',
    '😌 Calm',
    '💤 Rest',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: BackButton(color: primary),
        title: const Text(
          'Plan My Day',
          style: TextStyle(fontWeight: FontWeight.w600, color: primary),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlanHeaderOrb(),
                const SizedBox(height: 22),

                Text(
                  "Let’s shape today together",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose an intention and we’ll gently guide your day.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                _buildIntentions(),

                const SizedBox(height: 26),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.06),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: _selectedIntention == null
                      ? const SizedBox.shrink()
                      : DayPreviewCard(intention: _selectedIntention!),
                ),

                const SizedBox(height: 26),

                _buildCTA(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================
  // INTENTIONS
  // =============================
  Widget _buildIntentions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: intentions.map((i) {
        final selected = i == _selectedIntention;
        return GestureDetector(
          onTap: () => setState(() => _selectedIntention = i),
          child: IntentionChip(label: i, selected: selected),
        );
      }).toList(),
    );
  }

  // =============================
  // CTA
  // =============================
  Widget _buildCTA() {
    return ElevatedButton.icon(
      onPressed: _selectedIntention == null
          ? null
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your day has been gently planned 🌿"),
                ),
              );
            },
      icon: const Icon(Icons.auto_awesome),
      label: const Text("Start My Day"),
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
