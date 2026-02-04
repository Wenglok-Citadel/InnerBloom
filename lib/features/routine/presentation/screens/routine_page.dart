import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/features/companion_ai/presentation/screens/companion_ai_page.dart';
import 'package:inner_bloom_app/features/weekly_report/presentation/pages/weekly_report_page.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildDailyWellnessCard(),
              const SizedBox(height: 20),

              _buildStatsRow(),
              const SizedBox(height: 26),

              _buildSectionTitle("Daily Activities"),
              const SizedBox(height: 12),
              _buildActivityList(),

              const SizedBox(height: 26),
              _buildSectionTitle("Sleep Routine"),
              const SizedBox(height: 12),
              _buildSleepCard(),

              const SizedBox(height: 26),
              _buildSectionTitle("Weekly Mood Report"),
              const SizedBox(height: 12),
              _buildWeeklyMoodCard(context),

              const SizedBox(height: 26),
              _buildSectionTitle("Personalised AI companion"),
              const SizedBox(height: 12),
              _buildAICompanionTile(context),

              const SizedBox(height: 26),
              _buildSectionTitle("Recommended for You"),
              const SizedBox(height: 12),
              _buildRecommendedCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 1) Daily Wellness Summary
  // ----------------------------------------------------------

  Widget _buildDailyWellnessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Wellness Score",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "82",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: brandTeal,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "/ 100",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const Spacer(),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wb_sunny, color: brandTeal, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "You’re doing great today! Keep going 💚",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 2) Activity Stats Row
  // ----------------------------------------------------------

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("Steps", "8,701", Icons.directions_walk),
        _statCard("BPM", "78", Icons.favorite),
        _statCard("Active", "32m", Icons.bolt),
        _statCard("Calories", "416", Icons.local_fire_department),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: brandTeal),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text(title, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 3) Daily Activity List
  // ----------------------------------------------------------

  Widget _buildActivityList() {
    return Column(
      children: [
        _activityTile(
          "Breathing Exercise",
          "3 min • Relaxation",
          breathingExercise,
        ),
        const SizedBox(height: 12),
        _activityTile("Short Walk", "10 min • Outdoor", shortWalk),
      ],
    );
  }

  Widget _activityTile(String title, String subtitle, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 4) Sleep Card
  // ----------------------------------------------------------

  Widget _buildSleepCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Last Night Sleep",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text("7h 20m • Good sleep", style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 5) Weekly Mood Report Card
  // ----------------------------------------------------------

  Widget _buildWeeklyMoodCard(BuildContext context) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WeeklyReportScreen()),
    ),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.analytics, color: brandTeal, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Your weekly mood summary is ready.",
              style: TextStyle(fontSize: 15),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    ),
  );

  Widget _buildAICompanionTile(BuildContext context) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CompanionAIPage()),
    ),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.rocket_outlined,
              color: brandTeal,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Talk to your own personalised AI companion.",
              style: TextStyle(fontSize: 15),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    ),
  );

  // ----------------------------------------------------------
  // 6) Recommended Carousel
  // ----------------------------------------------------------

  Widget _buildRecommendedCarousel() {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          return Container(
            width: 160,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FIXED HEIGHT IMAGE CONTAINER
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(cycling, fit: BoxFit.cover),
                ),

                const SizedBox(height: 10),

                Text(
                  "Cycling",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }
}
