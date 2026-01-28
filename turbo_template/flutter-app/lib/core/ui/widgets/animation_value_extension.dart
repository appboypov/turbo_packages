import 'package:turbo_flutter_template/core/shared/extensions/num_extension.dart';

extension AnimationValueExtension on double {
  double get reversed => 1.0 - this;
  double get asFirstAnimation => maximum(1.0);
  double get asSecondAnimation => (this - 1).clamp(0, 1);
  double get asThirdAnimation => (this - 2).clamp(0, 1);
  double asOtherAnimation({required double indexStart}) => (this - indexStart).clamp(0, 1);
}
