import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/storage/converters/document_reference_converter.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

part 'username_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class UsernameDto extends TWriteableId {
  UsernameDto({
    required this.id,
    required this.documentReference,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String id;
  @JsonKey(includeFromJson: true, includeToJson: false)
  @DocumentReferenceConverter()
  final DocumentReference documentReference;
  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime updatedAt;
  final String userId;

  static const fromJsonFactory = _$UsernameDtoFromJson;
  factory UsernameDto.fromJson(Map<String, dynamic> json) =>
      _$UsernameDtoFromJson(json);
  static const toJsonFactory = _$UsernameDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$UsernameDtoToJson(this);
}
