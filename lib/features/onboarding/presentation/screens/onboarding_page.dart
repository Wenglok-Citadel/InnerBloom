import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/core/presentation/pages/main_home_screen.dart';
import 'package:inner_bloom_app/features/onboarding/models/onboard_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _current = 0;

  static const Color _brandTeal = Color(0xFF7BAEA9);

  final List<OnboardItem> _items = <OnboardItem>[
    OnboardItem(
      asset: onboardingItem1,
      title: 'Find Your Inner Calm',
      subtitle:
          'Discover a personalized path to emotional balance and well-being — made for you.',
    ),
    OnboardItem(
      asset: onboardingItem2,
      title: 'A Friend Who Listens',
      subtitle:
          'Chat anytime, in your language, and get thoughtful, culturally aware support.',
    ),
    OnboardItem(
      asset: onboardingItem3,
      title: 'Plans That Care for You',
      subtitle:
          'Receive daily routines and gentle reminders to help you feel better, one step at a time.',
    ),
    OnboardItem(
      asset: onboardingItem4,
      title: "You're Not Alone",
      subtitle:
          'Join supportive spaces where others share, listen, and grow together.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildPageView()),
            _buildBottomArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const Spacer(),
          if (_current != _items.length - 1)
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  _items.length - 1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _items.length,
      onPageChanged: (i) => setState(() => _current = i),
      itemBuilder: (context, index) => _buildSinglePage(_items[index]),
    );
  }

  Widget _buildSinglePage(OnboardItem item) {
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
            height: screenW * 1,
            child: Image.asset(item.asset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _brandTeal,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomArea(BuildContext context) {
    final bool last = _current == _items.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72.0, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!last) _buildDots(),
          const SizedBox(height: 20),
          if (last) _buildActionButton(context, last),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_items.length, (i) {
        final bool active = i == _current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: active ? 28 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? _brandTeal : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(BuildContext context, bool last) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainHomeScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          "Start blooming",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
