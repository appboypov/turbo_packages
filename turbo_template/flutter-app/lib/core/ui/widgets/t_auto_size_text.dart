import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TAutoSizeText extends AutoSizeText {
  const TAutoSizeText(
    super.data, {
    super.key,
    super.minFontSize = 8,
    super.maxLines = 1,
    super.textAlign = TextAlign.start,
    super.overflow = TextOverflow.ellipsis,
    super.style,
    AutoSizeGroup? autoSizeGroup,
  }) : super(group: autoSizeGroup);
}
