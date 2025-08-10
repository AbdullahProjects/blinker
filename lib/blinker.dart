import 'package:flutter/material.dart';

/// A Flutter widget for creating **blinking** or **shimmer-like**
/// color transitions on any child widget.
///
/// This widget supports two modes:
/// - **Shimmer mode**: Blinks between a base color and a highlight color.
/// - **Cycle mode**: Cycles smoothly through a list of colors.
///
/// Works on **all Flutter-supported platforms** (Android, iOS, Web, Windows, macOS, Linux)
/// because it only uses Flutter's rendering engine.
///
/// References:
/// - [ShaderMask](https://api.flutter.dev/flutter/widgets/ShaderMask-class.html)
/// - [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html)
/// - [ColorTween](https://api.flutter.dev/flutter/animation/ColorTween-class.html)
class Blinker extends StatefulWidget {
  /// Creates a shimmer-like effect between a base color and a highlight color.
  ///
  /// The `baseColor` and `highlightColor` must both be provided.
  /// This mode is useful for a loading shimmer effect or a blinking text highlight.
  const Blinker.shimmer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.duration = const Duration(milliseconds: 800),
    this.times,
  }) : colors = null,
       assert(
         baseColor != null && highlightColor != null,
         'baseColor and highlightColor must be provided',
       );

  /// Creates a cycle effect through a list of colors.
  ///
  /// The `colors` list must have at least **two** colors.
  /// The widget will smoothly transition from one color to the next.
  const Blinker.cycle({
    super.key,
    required this.child,
    required this.colors,
    this.duration = const Duration(milliseconds: 800),
    this.times,
  }) : baseColor = null,
       highlightColor = null,
       assert(
         colors != null && colors.length >= 2,
         'colors list must contain at least 2 colors',
       );

  /// The widget to which the blinking effect will be applied.
  final Widget child;

  /// Base color for shimmer effect (used in shimmer mode only).
  final Color? baseColor;

  /// Highlight color for shimmer effect (used in shimmer mode only).
  final Color? highlightColor;

  /// List of colors to cycle through (used in cycle mode only).
  final List<Color>? colors;

  /// Duration of each color transition.
  final Duration duration;

  /// Number of times to repeat the full animation cycle.
  ///
  /// If `null`, animation repeats infinitely.
  final int? times;

  @override
  BlinkerState createState() => BlinkerState();
}

class BlinkerState extends State<Blinker> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation timing.
  late Animation<Color?> _colorAnimation; // Produces color values over time.
  int _currentColorIndex = 0; // Tracks the current color in the sequence.
  int _cycleCount = 0; // Counts completed full cycles.
  late List<Color> colors; // Final list of colors to animate between.

  @override
  void initState() {
    super.initState();

    // Choose the correct color list based on constructor
    if (widget.baseColor != null && widget.highlightColor != null) {
      colors = [widget.baseColor!, widget.highlightColor!];
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
    _colorAnimation =
        ColorTween(
          begin: colors[_currentColorIndex],
          end: colors[(_currentColorIndex + 1) % colors.length],
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.linear, // Smooth linear color change
          ),
        );
  }

  /// Stops the animation when cycles are complete.
  void _endTween() {
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers
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
          blendMode: BlendMode.srcIn, // Replaces widget's color with gradient
          child: widget.child,
        );
      },
    );
  }
}
