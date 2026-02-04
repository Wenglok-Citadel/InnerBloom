import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/colors.dart';

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            const SizedBox(height: 16),
            _benefits(),
            const SizedBox(height: 20),
            _pricingOption(
              title: "Monthly",
              price: "RM 19.90",
              subtitle: "Billed monthly",
              highlight: false,
            ),
            const SizedBox(height: 12),
            _pricingOption(
              title: "Yearly",
              price: "RM 199",
              subtitle: "Save 15%",
              highlight: true,
            ),
            const SizedBox(height: 20),
            _subscribeButton(context),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Maybe later",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Icon(Icons.auto_awesome, size: 36, color: brandTeal),
        SizedBox(height: 8),
        Text(
          "InnerBloom Plus",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        Text(
          "Feel supported, every day",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _benefits() {
    final benefits = [
      "Unlimited AI Companion",
      "Premium Audio Sessions",
      "Daily Wellness Planner",
      "Early access features",
    ];

    return Column(
      children: benefits
          .map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 18, color: brandTeal),
                  const SizedBox(width: 10),
                  Expanded(child: Text(b)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _pricingOption({
    required String title,
    required String price,
    required String subtitle,
    required bool highlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? brandTeal.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: highlight ? brandTeal : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _subscribeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          // TODO: trigger in-app purchase flow
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: brandTeal,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Start Free Trial",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
