// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) {
  return Film(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    desc: json['desc'] as String,
    category: json['category'] == null
        ? null
        : FilmCategory.fromJson(json['category'] as Map<String, dynamic>),
    film_category_id: json['film_category_id'] as int,
    file: json['file'] as String,
    url: json['url'] as String,
    views: json['views'] as int,
  );
}

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'category': instance.category?.toJson(),
      'desc': instance.desc,
      'url': instance.url,
      'file': instance.file,
      'views': instance.views,
      'film_category_id': instance.film_category_id,
    };
