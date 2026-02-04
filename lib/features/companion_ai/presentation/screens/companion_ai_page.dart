import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/constants/colors.dart';
import 'package:inner_bloom_app/core/repository/firebase_auth_repository.dart';
import 'package:inner_bloom_app/features/boost_motivation/presentation/pages/boost_motivation_page.dart';
import 'package:inner_bloom_app/features/chat/presentation/screens/innerbloom_chat_page.dart';
import 'package:inner_bloom_app/features/mood_analyzer/presentation/widgets/mood_potion_generator.dart';
import 'package:inner_bloom_app/features/plan_my_day/presentation/screens/plan_my_day_page.dart';

class CompanionAIPage extends StatelessWidget {
  const CompanionAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              _buildGrid(context),

              const SizedBox(height: 30),

              _buildLargeTile(
                context,
                title: "Talk with InnerBloom",
                subtitle: "Tell me anything. I’m here for you 💛",
                icon: Icons.chat_bubble_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InnerBloomChatPage()),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 60,
              color: brandTeal,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Hey ${GetIt.instance<FirebaseAuthRepository>().name ?? ''}! 👋",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: brandTeal,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "I'm here for anything you need today.",
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      childAspectRatio: 1.1,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildTile(
          context,
          title: "Check My Mood",
          icon: Icons.emoji_emotions,
          color: Colors.yellow.shade100,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MoodPotionGenerator()),
            );
          },
        ),
        _buildTile(
          context,
          title: "Boost Motivation",
          icon: Icons.bolt_rounded,
          color: Colors.orange.shade100,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BoostMotivationPage()),
            );
          },        ),
        _buildTile(
          context,
          title: "Reduce Stress",
          icon: Icons.spa_rounded,
          color: Colors.blue.shade100,
          onTap: () {},
        ),
        _buildTile(
          context,
          title: "Calm Anxiety",
          icon: Icons.self_improvement_rounded,
          color: Colors.purple.shade100,
          onTap: () {},
        ),
        _buildTile(
          context,
          title: "Plan My Day",
          icon: Icons.calendar_today_rounded,
          color: Colors.green.shade100,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlanMyDayPage()),
            );
          },
        ),
        _buildTile(
          context,
          title: "Improve Sleep",
          icon: Icons.bedtime_rounded,
          color: Colors.indigo.shade100,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LARGE TILE (Talk with AI)
  // ----------------------------------------------------------
  Widget _buildLargeTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: brandTeal, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
