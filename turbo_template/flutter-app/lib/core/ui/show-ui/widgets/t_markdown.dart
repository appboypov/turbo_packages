import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/widgets/is_busy_icon.dart';
import 'package:roomy_mobile/typography/extensions/text_style_extension.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:veto/data/enums/busy_type.dart';
import 'package:veto/data/models/busy_model.dart';

enum MarkdownImageType { network, asset }

extension MarkdownImageExtension on Uri {
  MarkdownImageType get imageType {
    if (scheme == 'http' || scheme == 'https') {
      return MarkdownImageType.network;
    }
    return MarkdownImageType.asset;
  }

  String get assetPath {
    // The URI comes in as "images/lists.gif" so we need to prepend assets/md/
    final path = toString();
    return 'assets/md/$path';
  }
}

class TMarkdown extends StatelessWidget {
  const TMarkdown({Key? key, required this.text, this.onLinkPressed}) : super(key: key);

  final String text;
  final MarkdownTapLinkCallback? onLinkPressed;

  @override
  Widget build(BuildContext context) => MarkdownBody(
    data: text.replaceAll('   ', '\n\n'),
    selectable: true,
    // ignore: deprecated_member_use
    imageBuilder: (uri, title, alt) {
      final Widget imageWidget = switch (uri.imageType) {
        MarkdownImageType.network => CachedNetworkImage(
          imageUrl: uri.toString(),
          alignment: Alignment.center,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(
            height: 80,
            child: IsBusyIcon(
              busyModel: BusyModel(
                payload: null,
                busyType: BusyType.indicator,
                isBusy: true,
                busyMessage: null,
                busyTitle: null,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
        MarkdownImageType.asset => Image.asset(
          uri.assetPath,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      };

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: AnimatedContainer(
          duration: TDurations.animation,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: context.decorations.outerShadow,
            border: Border.all(color: context.colors.background.onColor, width: 2),
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(14), child: imageWidget),
        ),
      );
    },
    onTapLink: onLinkPressed,
    styleSheet: MarkdownStyleSheet(
      a: context.texts.p.copyWith(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
      blockquote: context.texts.blockquote,
      h1: context.texts.h3,
      horizontalRuleDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.buttonBorderRadius),
        border: Border(
          top: BorderSide(
            color: context.colors.background.onColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      h2: context.texts.h4,
      h2Padding: const EdgeInsets.only(top: 16),
      h3: context.texts.h5,
      h3Padding: const EdgeInsets.only(top: 12),
      h4: context.texts.h6,
      h4Padding: const EdgeInsets.only(top: 8),
      h5: context.texts.large,
      h6: context.texts.p.bold,
      p: context.texts.p,
      code: context.texts.mono,
      checkbox: context.texts.p,
      blockquoteDecoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(TSizes.buttonBorderRadius),
      ),
    ),
  );
}
