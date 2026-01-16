import 'package:gap/gap.dart';

/// A gap widget with convenient constructors for common spacing values.
class TurboGap extends Gap {
  const TurboGap(super.mainAxisExtent, {super.key});

  /// Standard app padding gap (16.0)
  const TurboGap.app({super.key, double multiplier = 1})
    : super(16.0 * multiplier);

  /// Card padding gap (12.0)
  const TurboGap.card({super.key, double multiplier = 1})
    : super(12.0 * multiplier);

  /// Small element gap (8.0)
  const TurboGap.element({super.key, double multiplier = 1})
    : super(8.0 * multiplier);

  /// Medium gap (12.0)
  const TurboGap.medium({super.key, double multiplier = 1})
    : super(12.0 * multiplier);

  /// Large gap (24.0)
  const TurboGap.large({super.key, double multiplier = 1})
    : super(24.0 * multiplier);

  /// Extra large gap (32.0)
  const TurboGap.xlarge({super.key, double multiplier = 1})
    : super(32.0 * multiplier);
}
