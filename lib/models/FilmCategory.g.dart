// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilmCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmCategory _$FilmCategoryFromJson(Map<String, dynamic> json) {
  return FilmCategory(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$FilmCategoryToJson(FilmCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
