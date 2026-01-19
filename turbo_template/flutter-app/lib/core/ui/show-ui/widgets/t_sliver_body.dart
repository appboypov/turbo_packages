import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_sliver_app_bar.dart';
import 'package:roomy_mobile/ui/widgets/t_sliver_scrollview.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_scrollview.dart';

class TSliverBody extends StatelessWidget {
  const TSliverBody({
    Key? key,
    this.slivers,
    this.children,
    this.appBarFooter,
    this.appBar,
    this.child,
    this.isEmpty = false,
    this.emptyPlaceholder,
    this.controller,
    this.onScrolled,
  }) : super(key: key);

  final List<Widget>? slivers;
  final List<Widget>? children;
  final TSliverAppBar? appBar;
  final Widget? child;
  final bool isEmpty;
  final WidgetBuilder? emptyPlaceholder;
  final ScrollController? controller;
  final Widget Function(ValueListenable<bool> isScrolled)? appBarFooter;
  final void Function(double scrolledPixels)? onScrolled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TSliverScrollView(
        appBarFooter: appBarFooter,
        controller: controller,
        slivers: slivers,
        children: children,
        appBar: appBar,
        child: child,
        isEmpty: isEmpty,
        emptyPlaceholder: emptyPlaceholder,
        onScrolled: onScrolled,
      ),
    );
  }
}
