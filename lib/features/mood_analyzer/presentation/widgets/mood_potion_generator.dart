import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inner_bloom_app/features/mood_analyzer/services/mood_analyzer.dart';
import 'liquid_potion.dart';

class MoodPotionGenerator extends StatefulWidget {
  const MoodPotionGenerator({super.key});

  @override
  _MoodPotionGeneratorState createState() => _MoodPotionGeneratorState();
}

class _MoodPotionGeneratorState extends State<MoodPotionGenerator>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isGenerating = false;
  MoodPotion? _potion;
  double _displayFill = 0.0;

  // tween between color A/B when potion arrives
  Color _colorA = Color(0xFFFFF1D6);
  Color _colorB = Color(0xFFE8F7F2);
  late AnimationController _fillAnimator;

  @override
  void initState() {
    super.initState();
    _fillAnimator = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    );
    _fillAnimator.addListener(() {
      setState(() {
        _displayFill = _fillAnimator.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fillAnimator.dispose();
    super.dispose();
  }

  Future<void> _onMixTap() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tell me how you felt today — one sentence.')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _potion = null;
      _displayFill = 0.0;
    });

    _fillAnimator.value = 0.05;
    _fillAnimator.forward(from: 0.05);

    // Simulate delay & generate with MoodAnalyzer
    await Future.delayed(Duration(milliseconds: 900));
    final result = MoodAnalyzer.analyzeTextMock(text);

    // prepare colors
    final newColorA = Color(result.gradientColors[0]);
    final newColorB = Color(result.gradientColors[1]);

    // animate color transition & fill
    // We'll animate fill to slightly below intensity then to final
    await Future.wait([
      _animateFillTo(result.intensity * 0.8, Duration(milliseconds: 700)),
    ]);

    // small pause to simulate mixing...
    await Future.delayed(Duration(milliseconds: 500));

    // finalize to intensity
    await _animateFillTo(result.intensity, Duration(milliseconds: 700));

    setState(() {
      _potion = result;
      _colorA = newColorA;
      _colorB = newColorB;
      _isGenerating = false;
    });
  }

  Future<void> _animateFillTo(double target, Duration d) async {
    final double start = _displayFill;
    final Completer c = Completer();
    final AnimationController a = AnimationController(vsync: this, duration: d);
    final Animation<double> anim = Tween<double>(
      begin: start,
      end: target,
    ).animate(CurvedAnimation(parent: a, curve: Curves.easeOut));
    anim.addListener(() {
      setState(() {
        _displayFill = anim.value;
      });
    });
    a.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        a.dispose();
        c.complete();
      }
    });
    a.forward();
    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF2F5C52),
        title: Text(
          'Mood Potion',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F5C52),
          ),
        ),
        leading: BackButton(color: Color(0xFF2F5C52)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Large centered potion jar
                  LiquidPotion(
                    size: 300,
                    fillPercent: _displayFill,
                    colorA: _colorA,
                    colorB: _colorB,
                    glowColor: Color(0xFF91B6A9),
                    animate: true,
                  ),

                  SizedBox(height: 22),

                  // Title & description (centered)
                  Text(
                    _potion?.name ?? 'Your potion will appear here',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F5C52),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _potion == null
                        ? 'Tell me how your day felt (e.g. "excited but a bit anxious")'
                        : 'A gentle reminder of how you are right now.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 18),

                  // Input card centered
                  Container(
                    constraints: BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(14),
                          child: TextField(
                            controller: _controller,
                            maxLines: 3,
                            minLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              hintText:
                                  'e.g. "I felt cheerful but a bit restless today"',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isGenerating ? null : _onMixTap,
                              icon: _isGenerating
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Icons.auto_fix_high_outlined),
                              label: Text(
                                _isGenerating ? 'Mixing...' : 'Start Mixing',
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Color(0xFF91B6A9),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  _potion = null;
                                  _displayFill = 0.0;
                                  _colorA = Color(0xFFFFF1D6);
                                  _colorB = Color(0xFFE8F7F2);
                                });
                              },
                              icon: Icon(Icons.refresh),
                              label: Text('Reset'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Result card (fades in)
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 420),
                    transitionBuilder: (child, anim) {
                      return FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween(
                            begin: Offset(0, 0.06),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      );
                    },
                    child: _potion == null
                        ? SizedBox.shrink()
                        : Container(
                            key: ValueKey('result_${_potion!.name}'),
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 18,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.06),
                              ),
                            ),
                            constraints: BoxConstraints(maxWidth: 720),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Your Exclusive Blend',
                                  style: theme.textTheme.bodySmall,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  _potion!.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      width: 84,
                                      height: 84,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(_potion!.gradientColors[0]),
                                            Color(_potion!.gradientColors[1]),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.06,
                                            ),
                                            blurRadius: 10,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildIngredientRow(
                                            'Top',
                                            _potion!.ingredientsTop,
                                          ),
                                          _buildIngredientRow(
                                            'Mid',
                                            _potion!.ingredientsMid,
                                          ),
                                          _buildIngredientRow(
                                            'Base',
                                            _potion!.ingredientsBase,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Intensity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  value: _potion!.intensity,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  color: Color(0xFF91B6A9),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '${(_potion!.intensity * 100).round()}%',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '"A little reminder to honour how you feel today."',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _onMixTap(),
                                        icon: Icon(Icons.autorenew),
                                        label: Text('Remix'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Saved to Mood Diary 🌟',
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.bookmark_border,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF2F5C52),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientRow(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              items.join(' • '),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
