import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/shared/typedefs/update_current_def.dart';

extension TextStyleExtensionExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle copyWithCurrent({
    UpdateCurrentDef<Color>? color,
    UpdateCurrentDef<Color>? backgroundColor,
    UpdateCurrentDef<double>? fontSize,
    UpdateCurrentDef<FontWeight>? fontWeight,
    UpdateCurrentDef<FontStyle>? fontStyle,
    UpdateCurrentDef<double>? letterSpacing,
    UpdateCurrentDef<double>? wordSpacing,
    UpdateCurrentDef<TextBaseline>? textBaseline,
    UpdateCurrentDef<double>? height,
    UpdateCurrentDef<String>? fontFamily,
    UpdateCurrentDef<TextOverflow>? overflow,
  }) {
    return copyWith(
      color: color?.call(this.color!),
      backgroundColor: backgroundColor?.call(this.backgroundColor!),
      fontSize: fontSize?.call(this.fontSize!),
      fontWeight: fontWeight?.call(this.fontWeight ?? FontWeight.normal),
      fontStyle: fontStyle?.call(this.fontStyle!),
      letterSpacing: letterSpacing?.call(this.letterSpacing!),
      wordSpacing: wordSpacing?.call(this.wordSpacing!),
      textBaseline: textBaseline?.call(this.textBaseline!),
      height: height?.call(this.height!),
      fontFamily: fontFamily?.call(this.fontFamily!),
      overflow: overflow?.call(this.overflow!),
    );
  }
}

extension AutoSizeTextExtension on AutoSizeText {
  AutoSizeText merge(TextStyle textStyle) => AutoSizeText(
    data!,
    style: textStyle.merge(style),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: softWrap,
    key: key,
    locale: locale,
    textDirection: textDirection,
    semanticsLabel: semanticsLabel,
    strutStyle: strutStyle,
    group: group,
    maxFontSize: maxFontSize,
    minFontSize: minFontSize,
    overflowReplacement: overflowReplacement,
    presetFontSizes: presetFontSizes,
    stepGranularity: stepGranularity,
    textKey: textKey,
    textScaleFactor: textScaleFactor,
    wrapWords: wrapWords,
  );
}

extension TextExtension on Text {
  Text merge(TextStyle textStyle) => Text(
    data!,
    style: textStyle.merge(style),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: softWrap,
    key: key,
    selectionColor: selectionColor,
    locale: locale,
    textDirection: textDirection,
    textHeightBehavior: textHeightBehavior,
    textScaler: textScaler,
    semanticsLabel: semanticsLabel,
    strutStyle: strutStyle,
    textWidthBasis: textWidthBasis,
  );
}
