// lib/services/mood_analyzer.dart
import 'dart:math';

/// Model returned by the analyzer
class MoodPotion {
  final String name;
  final List<String> ingredientsTop; // Top notes
  final List<String> ingredientsMid; // Mid notes
  final List<String> ingredientsBase; // Base notes
  final double intensity; // 0.0 - 1.0
  final List<int> gradientColors; // ARGB ints, two colors for gradient

  MoodPotion({
    required this.name,
    required this.ingredientsTop,
    required this.ingredientsMid,
    required this.ingredientsBase,
    required this.intensity,
    required this.gradientColors,
  });
}

/// Simple offline analyzer (works without network).
/// You can replace this by calling your backend or OpenAI.
class MoodAnalyzer {
  static final _rng = Random();

  /// Map simple keywords to ingredients and colors.
  static MoodPotion analyzeTextMock(String text) {
    final t = text.toLowerCase();

    // Determine intensity small heuristic
    double intensity = 0.5;
    if (t.contains('very') || t.contains('extremely') || t.contains('so')) intensity = 0.9;
    if (t.contains('a little') || t.contains('slightly')) intensity = 0.3;
    if (t.contains('ok') || t.contains('fine')) intensity = 0.45;
    if (t.contains('happy') || t.contains('excited') || t.contains('joy')) intensity = 0.8;
    if (t.contains('sad') || t.contains('down') || t.contains('tired')) intensity = 0.2;
    if (t.contains('anxious') || t.contains('nervous')) intensity = 0.4;
    if (t.contains('calm') || t.contains('relaxed')) intensity = 0.6;

    // Simple emotion pick
    String name;
    List<String> top = [], mid = [], base = [];
    List<int> grad = [];

    if (t.contains('happy') || t.contains('joy') || t.contains('excited')) {
      name = _pick(['Sunny Peach Uplift', 'Joyful Sparkler', 'Golden Smile']);
      top = ['Sparkling Citrus'];
      mid = ['Peach Cloud'];
      base = ['Warm Honey'];
      grad = [0xFFFFE59E, 0xFFFFB3A7]; // warm yellow -> soft peach
    } else if (t.contains('sad') || t.contains('down')) {
      name = _pick(['Calm Rain Tonic', 'Soft Indigo Brew', 'Blue Comfort']);
      top = ['Gentle Chamomile'];
      mid = ['Warm Milk'];
      base = ['Vanilla Root'];
      grad = [0xFFD7E8FF, 0xFFB2C8F8]; // soft blue gradient
      intensity = intensity.clamp(0.0, 0.6);
    } else if (t.contains('anxious') || t.contains('nervous')) {
      name = _pick(['Lavender Whisper', 'Quiet Breeze Elixir', 'Soothe Shot']);
      top = ['Mint Clarity'];
      mid = ['Lavender Cloud'];
      base = ['Warm Amber'];
      grad = [0xFFBFEFD9, 0xFFDDE8FF]; // mint -> lavender
      intensity = intensity.clamp(0.2, 0.8);
    } else if (t.contains('tired') || t.contains('exhausted')) {
      name = _pick(['Restful Night Draught', 'Moonlight Milk', 'Gentle Slumber']);
      top = ['Chamomile Mist'];
      mid = ['Oat Milk'];
      base = ['Lavender Root'];
      grad = [0xFFE9E9F9, 0xFFC6D6FF];
      intensity = (intensity * 0.7).clamp(0.0, 1.0);
    } else {
      // fallback blend: mix random happy + calm
      name = _pick(['Mixed Blossom', 'Warm Cloud', 'Breezy Blend']);
      top = ['Citrus Spark'];
      mid = ['Honey Vanilla'];
      base = ['Soft Amber'];
      grad = [0xFFFFF1D6, 0xFFE8F7F2];
    }

    // adjust with some randomness
    intensity = (intensity + (_rng.nextDouble() - 0.5) * 0.15).clamp(0.05, 0.95);

    return MoodPotion(
      name: name,
      ingredientsTop: top,
      ingredientsMid: mid,
      ingredientsBase: base,
      intensity: intensity,
      gradientColors: grad,
    );
  }

  static String _pick(List<String> items) {
    return items[_rng.nextInt(items.length)];
  }

// ------------------------------
// Optional: example snippet showing how you'd call OpenAI in your backend.
// (Don't call OpenAI from client directly — proxy via server and secure API key)
// ------------------------------
/*
  Future<MoodPotion> analyzeTextRemote(String text) async {
    // Build a prompt that returns JSON with name, top, mid, base, intensity, colors
    // Example prompt:
    // "Analyze the following user mood text and return a JSON object:
    // {name:..., top:[...], mid:[...], base:[...], intensity: 0.0-1.0, colors:[hex1,hex2] }.
    // User text: '...'
    //
    // Send to your server -> call OpenAI -> parse JSON -> return MoodPotion
  }
  */
}
