// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesEpisode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesEpisode _$SeriesEpisodeFromJson(Map<String, dynamic> json) {
  return SeriesEpisode(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    desc: json['desc'] as String,
    series: json['series'] == null
        ? null
        : Series.fromJson(json['series'] as Map<String, dynamic>),
    series_id: json['series_id'] as int,
    order: json['order'] as int,
    file: json['file'] as String,
    url: json['url'] as String,
    views: json['views'] as int,
  );
}

Map<String, dynamic> _$SeriesEpisodeToJson(SeriesEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'series': instance.series?.toJson(),
      'desc': instance.desc,
      'url': instance.url,
      'file': instance.file,
      'views': instance.views,
      'series_id': instance.series_id,
      'order': instance.order,
    };
