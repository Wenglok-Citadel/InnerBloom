import 'package:flutter/material.dart';
import 'package:inner_bloom_app/features/audio/presentation/widgets/control_button.dart';
import 'package:inner_bloom_app/features/audio/presentation/widgets/play_button.dart';

class AudioSessionPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final int durationInSeconds;

  const AudioSessionPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.durationInSeconds,
  });

  @override
  State<AudioSessionPage> createState() => _AudioSessionPageState();
}

class _AudioSessionPageState extends State<AudioSessionPage> {
  bool isPlaying = false;
  double progress = 0.0; // 0 → 1

  void togglePlay() {
    setState(() => isPlaying = !isPlaying);
  }

  String _formatTime(double value) {
    final seconds = (widget.durationInSeconds * value).round();
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Audio Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌊 Visual Focus
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFFBFE6D8), const Color(0xFFEAF7F2)],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.headphones,
                  size: 56,
                  color: Colors.teal.shade600,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 🎵 Title
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),

            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Column(
              children: [
                Slider(
                  value: progress,
                  onChanged: (v) {
                    setState(() => progress = v);
                  },
                  activeColor: Colors.teal,
                  inactiveColor: Colors.teal.withOpacity(0.2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(progress)),
                      Text(
                        _formatTime(1),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ControlButton(icon: Icons.replay_10, onTap: () {}),
                const SizedBox(width: 24),
                PlayButton(isPlaying: isPlaying, onTap: togglePlay),
                const SizedBox(width: 24),
                ControlButton(icon: Icons.forward_10, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
