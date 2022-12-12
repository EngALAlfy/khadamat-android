import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/models/User.dart';

part 'Category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  int id;
  String name;
  String image;
  int items_count;
  String created_at;
  List<SubCategory> subcategories;
  User created_user;

  Category(
      {this.id,
      this.items_count,
      this.name,
      this.image,
      this.subcategories,
      this.created_at,
      this.created_user});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
