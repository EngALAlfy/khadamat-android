// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesCategory _$SeriesCategoryFromJson(Map<String, dynamic> json) {
  return SeriesCategory(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$SeriesCategoryToJson(SeriesCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
