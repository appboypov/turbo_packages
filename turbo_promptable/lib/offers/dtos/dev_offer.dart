import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/core/globals/g_now.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

part 'dev_offer.g.dart';

@JsonSerializable(
  includeIfNull: true,
  explicitToJson: true,
)
class DevOffer extends TWriteableId {
  DevOffer({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const fromJsonFactory = _$DevOfferFromJson;
  factory DevOffer.fromJson(Map<String, dynamic> json) =>
      _$DevOfferFromJson(json);
  static const toJsonFactory = _$DevOfferToJson;
  @override
  Map<String, dynamic> toJson() => _$DevOfferToJson(this);

  DevOffer copyWith({
    String? id,
  }) {
    return DevOffer(
      id: id ?? this.id,
      createdAt: createdAt,
      updatedAt: gNow,
    );
  }
}
