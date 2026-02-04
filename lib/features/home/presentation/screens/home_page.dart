import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/core/repository/firebase_auth_repository.dart';
import 'package:inner_bloom_app/features/audio/presentation/pages/audio_session_page.dart';
import 'package:inner_bloom_app/features/mood_analyzer/presentation/widgets/mood_potion_generator.dart';
import 'package:inner_bloom_app/features/store/presentation/screens/store_page.dart';
import 'package:inner_bloom_app/features/therapist/presentation/screens/find_your_therapist_page.dart';
import 'package:inner_bloom_app/features/weekly_report/presentation/pages/weekly_report_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 18),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodPotionGenerator(),
                              ),
                            ),
                            child: _buildFeatureCard(
                              title: "Daily Mood Checking",
                              height: 140,
                              imagePath: dailyMoodTrackingPlaceholder,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeeklyReportScreen(),
                              ),
                            ),
                            child: _buildFeatureCard(
                              title: "Weekly report",
                              height: 140,
                              imagePath: weeklyReportPlaceholder,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildBannerFindTherapist(context),
                    const SizedBox(height: 26),

                    _buildSectionTitle("Audio Sessions"),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 6,
                        padding: const EdgeInsets.only(right: 12),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioSessionPage(
                                title:"Chapter 1: How to reduce stress",
                                subtitle: "",
                                durationInSeconds: 30,
                              ),
                            ),
                          ),
                          child: _buildAudioTile(index),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),
                    _buildSectionTitle("Today's Quote"),
                    const SizedBox(height: 12),
                    _buildQuoteCard(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: const Icon(Icons.person, color: Colors.black26, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Good Morning,",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                GetIt.instance<FirebaseAuthRepository>().name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: brandTeal,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StorePage()),
                );
              },
              child: _buildCoinButton(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoinButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.yellow.shade100],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.monetization_on, size: 18, color: Colors.orange),
          SizedBox(width: 6),
          Text(
            "100",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 18, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    double height = 120,
    required String imagePath,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Image.asset(fit: BoxFit.fitWidth, imagePath),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerFindTherapist(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 108,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Center(
              child: Image.asset(
                findYourTherapistPlaceholder,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Find your therapist",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Personalised professional support at your fingertips.",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FindTherapistPage()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text("Find", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAudioTile(int index) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Image.asset(audioPlaceholder, fit: BoxFit.fitWidth),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Session ${index + 1}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "5:00",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "“",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Today’s quote will appear here. A short inspiring sentence to brighten the user's day.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 90,
            height: 140,
            decoration: BoxDecoration(
              color: brandTeal,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: const Center(
              child: Icon(Icons.format_quote, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }
}
