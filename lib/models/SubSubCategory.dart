import 'package:json_annotation/json_annotation.dart';
import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/models/User.dart';

part 'SubSubCategory.g.dart';

@JsonSerializable(explicitToJson: true)
class SubSubCategory{
  int id;
  String name;
  String image;
  int items_count;
  Category category;
  SubCategory subcategory;
  String category_id;
  String subcategory_id;
  String created_at;
  User created_user;

  SubSubCategory({this.id,this.category_id, this.items_count , this.name,this.subcategory_id,this.subcategory, this.image, this.category, this.created_at,
      this.created_user});

  factory SubSubCategory.fromJson(Map<String, dynamic> json) => _$SubSubCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubSubCategoryToJson(this);
}