import 'package:gap/gap.dart';

abstract final class TSpacings {
  static const double appPadding = 24.0;
  static const double appPaddingX0p5 = 12.0;
  static const double appPaddingX0p75 = 18.0;
  static const double appPaddingX2 = 48.0;

  static const double elementGap = 16.0;
  static const double sectionGap = 24.0;
  static const double itemGap = 12.0;
  static const double textGap = 8.0;
  static const double subtitleGap = 4.0;
  static const double labelGap = 12.0;
  static const double titleGap = 16.0;

  static const double cardPadding = 24.0;
  static const double cardRadius = 24.0;
}

class TGap extends Gap {
  const TGap(super.mainAxisExtent, {super.key});

  const TGap.element({super.key, double multiplier = 1})
      : super(TSpacings.elementGap * multiplier);

  const TGap.subtitle({super.key, double multiplier = 1})
      : super(TSpacings.subtitleGap * multiplier);

  const TGap.app({super.key, double multiplier = 1})
      : super(TSpacings.appPadding * multiplier);

  const TGap.card({super.key, double multiplier = 1})
      : super(TSpacings.cardPadding * multiplier);

  const TGap.section({super.key, double multiplier = 1})
      : super(TSpacings.sectionGap * multiplier);

  const TGap.item({super.key, double multiplier = 1})
      : super(TSpacings.itemGap * multiplier);

  const TGap.text({super.key, double multiplier = 1})
      : super(TSpacings.textGap * multiplier);

  const TGap.label({super.key, double multiplier = 1})
      : super(TSpacings.labelGap * multiplier);

  const TGap.title({super.key, double multiplier = 1})
      : super(TSpacings.titleGap * multiplier);
}
