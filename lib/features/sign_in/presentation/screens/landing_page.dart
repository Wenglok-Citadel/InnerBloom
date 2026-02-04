import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/screens/sign_in_screen.dart';

/// This page will be rendered as a landing page.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const Color brandTeal = Color(0xFF7BAEA9);

  final String assetLogoPath = innerBloomImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFC),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLanguageButton(),
            _buildLogoSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildSignInButton(context),
                  const SizedBox(height: 12),
                  _buildTermsText(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16,top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🇬🇧", style: TextStyle(fontSize: 18)),
            SizedBox(width: 6),
            Text(
              "EN",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: brandTeal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        _buildLogo(),

        Text(
          "Version 1.0.0",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildLogo() => ClipRRect(
    borderRadius: BorderRadius.circular(0),
    child: Image.asset(assetLogoPath, fit: BoxFit.contain, height: 180),
  );

  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: brandTeal,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: brandTeal.withOpacity(0.2)),
          ),
        ),
        child: const Text(
          "Sign In",
          style: TextStyle(
            color: brandTeal,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(color: Colors.grey, fontSize: 12),
        children: [
          TextSpan(
            text: "By signing up for and using InnerBloom, you agree to our ",
          ),
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: brandTeal,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: brandTeal,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(text: "."),
        ],
      ),
    );
  }
}
