import 'package:flutter/material.dart';

/// A Flutter widget for creating **color transition** or **color cycling**
/// animations on any child widget.
///
/// This widget supports two modes:
/// - **Fade mode** [Blinker.fade]: Transitions between a start color and an end color.
/// - **Cycle mode** [Blinker.cycle]: Cycles smoothly through a list of colors.
///
/// Works on **all Flutter-supported platforms** (Android, iOS, Web, Windows, macOS, Linux)
/// because it only uses Flutter's rendering engine.
///
/// References:
/// - [ShaderMask](https://api.flutter.dev/flutter/widgets/ShaderMask-class.html)
/// - [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html)
/// - [ColorTween](https://api.flutter.dev/flutter/animation/ColorTween-class.html)
class Blinker extends StatefulWidget {
  /// Creates a fade transition between a start color and an end color.
  ///
  /// The [startColor] and [endColor] must both be provided.
  /// This mode is useful for a simple blinking effect or highlighting a widget.
  const Blinker.fade({
    super.key,
    required this.startColor,
    required this.endColor,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.linear,
    this.times,
  })  : colors = null,
        assert(
          startColor != null && endColor != null,
          'startColor and endColor must be provided',
        );

  /// Creates a cycle effect through a list of colors.
  ///
  /// The [colors] list must have at least **two** colors.
  /// The widget will smoothly transition from one color to the next.
  const Blinker.cycle({
    super.key,
    required this.colors,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.linear,
    this.times,
  })  : startColor = null,
        endColor = null,
        assert(
          colors != null && colors.length >= 2,
          'colors list must contain at least 2 colors',
        );

  /// The widget to which the blinking effect will be applied.
  final Widget child;

  /// Start color for fade effect (used in fade mode only [Blinker.fade]).
  final Color? startColor;

  /// End color for fade effect (used in fade mode only [Blinker.fade]).
  final Color? endColor;

  /// List of colors to cycle through (used in cycle mode only [Blinker.cycle]).
  final List<Color>? colors;

  /// Duration of each color transition.
  final Duration duration;

  /// The curve to use for the animation.
  final Curve curve;

  /// Number of times to repeat the full animation cycle.
  ///
  /// If `null`, animation repeats infinitely.
  ///
  /// If times is set, the animation will stop after completing the specified number of cycles,
  /// and final color will be the first color in [Blinker.cycle],
  /// or the start color in fade mode [Blinker.fade].
  final int? times;

  @override
  BlinkerState createState() => BlinkerState();
}

class BlinkerState extends State<Blinker> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation timing
  late Animation<Color?> _colorAnimation; // Produces color values over time
  int _currentColorIndex = 0; // Tracks the current color in the sequence
  int _cycleCount = 0; // Counts completed full cycles
  late List<Color> colors; // Final list of colors to animate between

  @override
  void initState() {
    super.initState();

    // Choose the correct color list based on constructor
    if (widget.startColor != null && widget.endColor != null) {
      colors = [widget.startColor!, widget.endColor!];
    } else {
      colors = widget.colors!;
    }

    // Initialize the animation controller with given duration
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Prepare the first color transition
    _updateColorAnimation();

    // Listen for animation status changes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Move to the next color in the sequence
        _currentColorIndex = (_currentColorIndex + 1) % colors.length;

        // If we looped back to the first color, we completed a full cycle
        if (_currentColorIndex == 0) {
          _cycleCount++;
          // Stop animation if we have reached the required times
          if (widget.times != null && _cycleCount >= widget.times!) {
            _endTween();
            return;
          }
        }

        // Prepare next transition
        _updateColorAnimation();

        // Restart animation for next transition
        _controller
          ..reset()
          ..forward();
      }
    });

    // Start the animation
    _controller.forward();
  }

  /// Updates the [_colorAnimation] with the current and next color.
  void _updateColorAnimation() {
    _colorAnimation = ColorTween(
      begin: colors[_currentColorIndex],
      end: colors[(_currentColorIndex + 1) % colors.length],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
  }

  /// Stops the animation when cycles are complete.
  void _endTween() {
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              _colorAnimation.value ?? colors.first,
              _colorAnimation.value ?? colors.first,
            ],
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}
