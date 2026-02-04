import 'package:flutter/material.dart';
import 'package:inner_bloom_app/constants/strings.dart';

class Illustration extends StatelessWidget {
  const Illustration({super.key});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.55;

    return Center(
      child: Image.asset(
        assetIllustrationPath,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (ctx, err, st) => const SizedBox.shrink(),
      ),
    );
  }
}
