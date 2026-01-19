import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/context_def.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_row.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/emoji_title.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TSliverAppBar extends StatefulWidget {
  const TSliverAppBar({
    Key? key,
    this.leading,
    required this.emoji,
    required this.title,
    this.header,
    this.actions,
    required this.onBackPressed,
    this.appBarGap = TSizes.appBarGap,
    this.controller,
  }) : super(key: key);

  final Widget? leading;
  final Emoji? emoji;
  final String? title;
  final Widget? header;
  final List<Widget>? actions;
  final NamedContextDef? onBackPressed;
  final double appBarGap;
  final ScrollController? controller;

  @override
  State<TSliverAppBar> createState() => _TSliverAppBarState();
}

class _TSliverAppBarState extends State<TSliverAppBar> {
  bool _showBorder = false;

  @override
  void initState() {
    super.initState();
    _updateBorderVisibility();
    widget.controller?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant TSliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onScroll);
      widget.controller?.addListener(_onScroll);
      _updateBorderVisibility();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    _updateBorderVisibility();
  }

  void _updateBorderVisibility() {
    final currentScrollOffset = widget.controller != null && widget.controller!.hasClients
        ? widget.controller!.offset
        : 0.0;

    final newShouldShowBorder = currentScrollOffset > 0 && widget.controller?.hasClients == true;

    if (_showBorder != newShouldShowBorder) {
      if (mounted) {
        setState(() {
          _showBorder = newShouldShowBorder;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => SliverAppBar(
    floating: true,
    automaticallyImplyLeading: false,
    backgroundColor: context.colors.background,
    surfaceTintColor: Colors.transparent,
    toolbarHeight: 0,
    expandedHeight: kToolbarHeight + widget.appBarGap,
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
      background: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: widget.appBarGap > 0 ? EdgeInsets.only(bottom: widget.appBarGap) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TGap.appBarSpacing(),
                if (widget.onBackPressed != null)
                  Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.only(right: TSizes.appPadding / 2),
                      child: ShadIconButton.ghost(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => widget.onBackPressed!(context: context),
                      ),
                    ),
                  ),
                if (widget.leading != null) widget.leading!,
                if (widget.title != null)
                  Expanded(
                    child: EmojiTitle.scaffoldTitle(title: widget.title!, emoji: widget.emoji),
                  ),
                if (widget.header != null) widget.header!,
                if (widget.actions != null) ...[
                  const TGap.appBarSpacing(),
                  TRow(children: widget.actions!, spacing: 0),
                ],
                const TGap.appBarSpacing(),
              ],
            ),
          ),
          if (_showBorder)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 10.0, color: context.colors.border),
            ),
        ],
      ),
    ),
  );
}
