import 'package:json_annotation/json_annotation.dart';


part 'FilmCategory.g.dart';

@JsonSerializable(explicitToJson: true)
class FilmCategory {
  int id;
  String name;
  String image;

  FilmCategory(
      {this.id,
      this.name,
      this.image,});

  factory FilmCategory.fromJson(Map<String, dynamic> json) =>
      _$FilmCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$FilmCategoryToJson(this);
}
