import 'package:json_annotation/json_annotation.dart';


part 'SeriesCategory.g.dart';

@JsonSerializable(explicitToJson: true)
class SeriesCategory {
  int id;
  String name;
  String image;

  SeriesCategory(
      {this.id,
      this.name,
      this.image,});

  factory SeriesCategory.fromJson(Map<String, dynamic> json) =>
      _$SeriesCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesCategoryToJson(this);
}
