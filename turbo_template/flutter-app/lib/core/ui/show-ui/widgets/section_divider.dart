import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/data/constants/k_sizes.dart';
import 'package:roomy_mobile/ui/widgets/tu_divider.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      const TuDivider(topPadding: kSizesSectionGap, bottomPadding: kAppPadding);
}
