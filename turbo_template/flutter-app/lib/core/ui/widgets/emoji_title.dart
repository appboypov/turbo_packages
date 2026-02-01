import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_auto_size_text.dart';

enum EmojiTitleType { scaffoldTitle, h1, h2, h3 }

class EmojiTitle extends StatelessWidget {
  const EmojiTitle.scaffoldTitle({
    super.key,
    required this.emoji,
    required this.title,
    this.textAlign = TextAlign.left,
    this.color,
  }) : type = EmojiTitleType.scaffoldTitle;

  const EmojiTitle.h1({
    super.key,
    required this.emoji,
    required this.title,
    this.textAlign = TextAlign.left,
    this.color,
  }) : type = EmojiTitleType.h1;

  const EmojiTitle.h2({
    super.key,
    required this.emoji,
    required this.title,
    this.textAlign = TextAlign.left,
    this.color,
  }) : type = EmojiTitleType.h2;

  const EmojiTitle.h3({
    super.key,
    required this.emoji,
    required this.title,
    this.textAlign = TextAlign.left,
    this.color,
  }) : type = EmojiTitleType.h3;

  final Color? color;
  final Emoji? emoji;
  final EmojiTitleType type;
  final String title;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: const Offset(0, 2),
    child: TAutoSizeText(
      minFontSize: 18,
      '$title'.butWhen(
        emoji != null,
        (cValue) => '${emoji.toString()}  $cValue',
      ),
      style: switch (type) {
        EmojiTitleType.scaffoldTitle => context.texts.h2,
        EmojiTitleType.h1 => context.texts.h1,
        EmojiTitleType.h2 => context.texts.h2,
        EmojiTitleType.h3 => context.texts.h3,
      },
      textAlign: textAlign,
    ),
  );
}
