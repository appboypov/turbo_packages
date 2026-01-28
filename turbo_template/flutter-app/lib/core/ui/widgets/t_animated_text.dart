import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';

/// A widget that animates text changes with a sequential fade transition.
///
/// This widget wraps a [Text] widget with an [AnimatedSwitcher] to provide
/// smooth fade transitions when the text content changes. The animation consists
/// of a fade out of the old text followed by a fade in of the new text.
///
/// fade in and fade out transitions.
class TAnimatedText extends StatelessWidget {
  /// Creates a TAnimatedText widget.
  ///
  /// The [text] parameter is required and specifies the text to display.
  /// The [style] parameter is optional and specifies the text style.
  /// The [textAlign] parameter is optional and specifies how to align the text.
  /// The [alignment] parameter is optional and specifies how to align the text within its bounds.
  /// The [duration] parameter is optional and specifies the animation duration.
  /// The [curve] parameter is optional and specifies the animation curve.
  const TAnimatedText({
    required this.text,
    this.style,
    this.textAlign,
    this.alignment = Alignment.topLeft,
    this.duration = TDurations.animation,
    this.curve = Curves.fastOutSlowIn,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The style to use for the text.
  final TextStyle? style;

  /// How to align the text within its bounds.
  final Alignment alignment;

  /// How to align the text lines relative to each other.
  final TextAlign? textAlign;

  /// The duration of the animation.
  final Duration duration;

  /// The curve to use for the animation.
  final Curve curve;

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: duration,
    clipBehavior: Clip.none,
    curve: curve,
    alignment: alignment,
    child: AnimatedSwitcher(
      duration: duration,
      reverseDuration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: alignment,
          children: <Widget>[...previousChildren, if (currentChild != null) currentChild],
        );
      },
      child: Text(text, key: ValueKey<String>(text), style: style, textAlign: textAlign),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
    ),
  );
}
