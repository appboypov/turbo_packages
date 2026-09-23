// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevOffer _$DevOfferFromJson(Map<String, dynamic> json) => DevOffer(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DevOfferToJson(DevOffer instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
