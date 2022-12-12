import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/SeriesCategory.dart';

part 'Series.g.dart';

@JsonSerializable(explicitToJson: true)
class Series {
  int id;
  String name;
  String image;
  SeriesCategory category;
  String desc;
  int series_category_id;

  Series({
    this.id,
    this.name,
    this.image,
    this.desc,
    this.category,
    this.series_category_id,
  });

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
