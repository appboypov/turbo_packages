import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_divider.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const TMargin(
    child: TDivider(),
  );
}
