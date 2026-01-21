import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TGap extends Gap {
  const TGap(super.mainAxisExtent, {super.key});

  const TGap.appBarSpacing({super.key, double multiplier = 1})
    : super(TSizes.appBarSpacing * multiplier);
  const TGap.element({super.key, double multiplier = 1}) : super(TSizes.elementGap * multiplier);
  const TGap.subtitle({super.key, double multiplier = 1}) : super(TSizes.subtitleGap * multiplier);
  const TGap.app({super.key, double multiplier = 1}) : super(TSizes.appPadding * multiplier);
  const TGap.card({super.key, double multiplier = 1}) : super(TSizes.cardPadding * multiplier);
  const TGap.bottomFade({super.key, double multiplier = 1})
    : super(TSizes.heightButtonBottomFade * multiplier);
  const TGap.headerTitle({super.key, double multiplier = 1}) : super(TSizes.titleGap * multiplier);
  const TGap.listItemTitleCaption({super.key, double multiplier = 1})
    : super(TSizes.listItemTitleCaption * multiplier);
  const TGap.inlineText({super.key, double multiplier = 1}) : super(TSizes.textGap * multiplier);
  const TGap.label({super.key, double multiplier = 1}) : super(TSizes.itemGap * multiplier);
  const TGap.listItem({super.key, double multiplier = 1}) : super(TSizes.listItemGap * multiplier);
  const TGap.scaffoldTitle({super.key, double multiplier = 1})
    : super(TSizes.titleGap * multiplier);
  const TGap.section({super.key, double multiplier = 1}) : super(TSizes.sectionGap * multiplier);
  factory TGap.bottomSafeArea(BuildContext context, {double multiplier = 1}) =>
      TGap(context.sizes.bottomSafeAreaWithMinimum * multiplier);
  factory TGap.topSafeArea(BuildContext context, {double multiplier = 1}) =>
      TGap(context.sizes.topSafeArea * multiplier);
}
