import 'package:turbo_promptable/intents/dtos/t_intent_dto.dart';

/// One outcome the user wants, backed by a [TIntentDto].
class TIntent {
  const TIntent({required this.dto});

  final TIntentDto dto;

  String get id => dto.id;

  TIntent copyWith({TIntentDto? dto}) => TIntent(dto: dto ?? this.dto);
}
