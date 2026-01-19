import 'package:flutter/material.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';

class TChip extends StatelessWidget {
  const TChip({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    height: 24,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      color: context.colors.card,
      border: Border.all(color: context.colors.border, width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Text(
          text,
          style: context.texts.mono.copyWith(height: 1, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
      ],
    ),
  );
}
