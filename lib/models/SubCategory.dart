import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/models/SubSubCategory.dart';
import 'package:khadamat_app/models/User.dart';

part 'SubCategory.g.dart';

@JsonSerializable(explicitToJson: true)
class SubCategory{
  int id;
  String name;
  String image;
  int items_count;
  Category category;
  List<SubSubCategory> subsubcategories;
  int category_id;
  String created_at;
  User created_user;

  SubCategory({this.id,this.category_id, this.subsubcategories, this.items_count , this.name, this.image, this.category, this.created_at,
      this.created_user});

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}