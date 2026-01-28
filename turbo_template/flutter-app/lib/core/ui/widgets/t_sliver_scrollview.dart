import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_animated_divider.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class TSliverScrollView extends HookWidget {
  const TSliverScrollView({
    Key? key,
    this.anchor = 0.0,
    this.cacheExtent,
    this.center,
    this.children,
    this.appBar,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.physics = const BouncingScrollPhysics(),
    this.primary,
    this.restorationId,
    this.reverse = false,
    this.scrollBehavior,
    this.scrollDirection = Axis.vertical,
    this.semanticChildCount,
    this.shrinkWrap = false,
    this.slivers,
    this.pushPinnedChildren = false,
    this.child,
    this.isEmpty = false,
    this.emptyPlaceholder,
    this.appBarFooter,
    this.onScrolled,
  }) : super(key: key);

  final Axis scrollDirection;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior hitTestBehavior;
  final List<Widget>? children;
  final List<Widget>? slivers;
  final ScrollBehavior? scrollBehavior;
  final ScrollController? controller;
  final ScrollPhysics physics;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final bool reverse;
  final bool shrinkWrap;
  final bool? primary;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final Key? center;
  final bool pushPinnedChildren;
  final TSliverAppBar? appBar;
  final Widget? child;
  final bool isEmpty;
  final WidgetBuilder? emptyPlaceholder;
  final Widget Function(ValueListenable<bool> isScrolled)? appBarFooter;
  final void Function(double scrolledPixels)? onScrolled;

  @override
  Widget build(BuildContext context) {
    final showEmptyPlaceholder = isEmpty && emptyPlaceholder != null;
    final scrollController = controller ?? useScrollController();
    final showBorder = useState(false);
    _manageBorder(showEmptyPlaceholder, showBorder, scrollController);
    final customScrollView = CustomScrollView(
      anchor: anchor,
      cacheExtent: cacheExtent,
      center: center,
      clipBehavior: clipBehavior,
      controller: scrollController,
      dragStartBehavior: dragStartBehavior,
      hitTestBehavior: hitTestBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: physics,
      primary: primary,
      restorationId: restorationId,
      reverse: reverse,
      scrollBehavior: scrollBehavior,
      scrollDirection: scrollDirection,
      semanticChildCount: semanticChildCount,
      shrinkWrap: shrinkWrap,
      slivers: [
        if (appBar != null) appBar!,
        if (appBarFooter != null)
          SliverPinnedHeader(key: const Key('appBarFooter'), child: appBarFooter!.call(showBorder)),
        if (appBar != null)
          SliverPinnedHeader(
            key: const Key('appBarBorder'),
            child: ValueListenableBuilder<bool>(
              valueListenable: showBorder,
              builder: (context, value, child) => TAnimatedDivider(show: value),
            ),
          ),
        if (slivers != null && !showEmptyPlaceholder) ...slivers!,
        if (child != null && !showEmptyPlaceholder) SliverToBoxAdapter(child: child),
        if (children != null && !showEmptyPlaceholder)
          MultiSliver(children: children!, pushPinnedChildren: pushPinnedChildren),
        if (showEmptyPlaceholder)
          SliverFillRemaining(hasScrollBody: false, child: emptyPlaceholder!(context)),
      ],
    );
    return switch (context.data.deviceType) {
      TDeviceType.mobile => customScrollView,
      TDeviceType.tablet => TMargin(child: customScrollView, bottom: 0),
      TDeviceType.desktop => TMargin(child: customScrollView, bottom: 0),
    };
  }

  void _manageBorder(
    bool showEmptyPlaceholder,
    ValueNotifier<bool> showBorder,
    ScrollController scrollController,
  ) {
    useEffect(() {
      void updateShowBorder() {
        if (showEmptyPlaceholder) {
          if (showBorder.value) {
            showBorder.value = false;
          }
          return;
        }

        onScrolled?.call(scrollController.offset);

        final isCurrentlyShowingBorder = showBorder.value;
        if (isCurrentlyShowingBorder) {
          if (scrollController.offset > 0) {
            return;
          }
          showBorder.value = false;
        } else {
          showBorder.value = scrollController.offset > kToolbarHeight;
          if (showBorder.value) {}
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => updateShowBorder());

      scrollController.addListener(updateShowBorder);
      return () => scrollController.removeListener(updateShowBorder);
    }, [scrollController, showEmptyPlaceholder]);
  }
}
