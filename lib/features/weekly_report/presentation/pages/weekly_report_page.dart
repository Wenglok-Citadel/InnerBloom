import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/features/weekly_report/models/mood_day.dart';
import 'package:inner_bloom_app/features/weekly_report/presentation/widgets/mood_row.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Weekly Report',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: brandTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroSummary(),
            const SizedBox(height: 20),
            _weeklyMoodGraph(),
            const SizedBox(height: 20),
            _moodHistoryList(),
            const SizedBox(height: 20),
            _moodBreakdown(),
            const SizedBox(height: 20),
            _playfulInsights(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _heroSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Your Week at a Glance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text(
            "😊 Calm & Balanced",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            "You maintained a steady emotional state most of the week.",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _weeklyMoodGraph() {
    final moods = [
      MoodDay(label: "M", level: 0.7),
      MoodDay(label: "T", level: 0.6),
      MoodDay(label: "W", level: 0.3),
      MoodDay(label: "T", level: 0.5),
      MoodDay(label: "F", level: 0.6),
      MoodDay(label: "S", level: 0.8),
      MoodDay(label: "S", level: 0.75),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Mood This Week",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: moods.map((m) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 90 * m.level,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _moodColor(m.level),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(m.label, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _moodHistoryList() {
    final entries = [
      {'title': 'Golden Smile', 'subtitle': 'Happy • 2 days ago'},
      {'title': 'Lavender Whisper', 'subtitle': 'Calm • 3 days ago'},
      {'title': 'Heavy Rain Tonic', 'subtitle': 'Stressed • 6 days ago'},
    ];

    return Column(
      children: entries
          .map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ListTile(
                minVerticalPadding: 12,
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF1D6), Color(0xFFFFB3A7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: Colors.white70),
                  ),
                ),
                title: Text(
                  e['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(e['subtitle'] as String),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            ),
          )
          .toList(),
    );
  }

  Color _moodColor(double level) {
    if (level > 0.65) return const Color(0xFF91B6A9); // calm
    if (level > 0.45) return Colors.amber.shade400; // neutral
    return Colors.red.shade300; // stressed
  }

  Widget _moodBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mood Breakdown",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          MoodRow(label: "Calm", value: "4 days"),
          MoodRow(label: "Neutral", value: "2 days"),
          MoodRow(label: "Stressed", value: "1 day"),
        ],
      ),
    );
  }

  Widget _playfulInsights() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "What We Noticed 👀",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "• Mid-week felt a little heavier than usual.\n"
            "• Your mood lifted again towards the weekend 🌤️\n\n"
            "This pattern is common — it usually means you’re pushing hard, then recovering well.",
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  BoxDecoration _card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
