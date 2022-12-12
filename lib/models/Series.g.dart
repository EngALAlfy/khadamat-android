// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return Series(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    desc: json['desc'] as String,
    category: json['category'] == null
        ? null
        : SeriesCategory.fromJson(json['category'] as Map<String, dynamic>),
    series_category_id: json['series_category_id'] as int,
  );
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'category': instance.category?.toJson(),
      'desc': instance.desc,
      'series_category_id': instance.series_category_id,
    };
