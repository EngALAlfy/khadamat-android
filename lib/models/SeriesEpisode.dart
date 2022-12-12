import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/Series.dart';

part 'SeriesEpisode.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesEpisode {
  int id;
  String name;
  String image;
  Series series;
  String desc;
  String url;
  String file;
  int views;
  int series_id;
  int order;

  SeriesEpisode({
    this.id,
    this.name,
    this.image,
    this.desc,
    this.series,
    this.series_id,
    this.order,
    this.file,
    this.url,
    this.views,
  });

  factory SeriesEpisode.fromJson(Map<String, dynamic> json) => _$SeriesEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesEpisodeToJson(this);
}
