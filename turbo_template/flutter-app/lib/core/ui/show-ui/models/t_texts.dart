part of '../widgets/t_provider.dart';

import 'package:turbo_flutter_template/core/ui/show-ui/models/t_colors.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_sizes.dart';

class TTexts {
  const TTexts({required this.colors, required this.sizes, required this.theme});

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final TColors colors;
  final TSizes sizes;
  final TTheme theme;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ShadTextTheme get textTheme => theme.text;

  TextStyle get mono => small.copyWith(
    fontFamily: FontFamily.jetBrainsMono,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.7,
    letterSpacing: 0.8,
  );

  TextStyle get blockquote => textTheme.blockquote;
  TextStyle get button => textTheme.small.copyWith(fontWeight: FontWeight.w800);
  TextStyle get h1 => textTheme.h1;
  TextStyle get h1Large => textTheme.h1Large;
  TextStyle get h2 => textTheme.h2;
  TextStyle get h3 => textTheme.h3;
  TextStyle get h4 => textTheme.h4;
  TextStyle get h5 => textTheme.h4.copyWithCurrent(fontSize: (cValue) => cValue * 0.9);
  TextStyle get h6 => textTheme.h4.copyWithCurrent(fontSize: (cValue) => cValue * 0.8);
  TextStyle get large => textTheme.large;
  TextStyle get lead => textTheme.lead;
  TextStyle get list => textTheme.list;
  TextStyle get muted => textTheme.muted;
  TextStyle get xMuted => textTheme.muted.copyWithCurrent(fontSize: (cValue) => cValue * 0.9);
  TextStyle get p => textTheme.p;
  TextStyle get small => textTheme.small;
  TextStyle get smallDestructive => textTheme.small.copyWith(color: colors.destructive);
  TextStyle get table => textTheme.table;

  // Use Cases

  TextStyle get subtitle => muted;
}
