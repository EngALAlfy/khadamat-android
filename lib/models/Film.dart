import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/FilmCategory.dart';


part 'Film.g.dart';

@JsonSerializable(explicitToJson: true)
class Film {
  int id;
  String name;
  String image;
  FilmCategory category;
  String desc;
  String url;
  String file;
  int views;
  int film_category_id;

  Film({
    this.id,
    this.name,
    this.image,
    this.desc,
    this.category,
    this.film_category_id,
    this.file,
    this.url,
    this.views,
  });

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);

  Map<String, dynamic> toJson() => _$FilmToJson(this);
}
