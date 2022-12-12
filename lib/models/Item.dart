import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/models/SubSubCategory.dart';
import 'package:khadamat_app/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Item.g.dart';

@JsonSerializable(explicitToJson: true)
class Item {
  int id;
  String name;
  String desc;
  String image;
  String image1;
  String image2;
  String image3;
  String image4;
  String phone;
  String email;
  User created_user;
  String created_at;
  Category category;
  SubCategory subcategory;
  SubSubCategory subsubcategory;
  int views;
  int sponsored;
  int archived;
  int sponsored_index;

  Item({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.image1,
    this.image2,
    this.image3,
    this.archived,
    this.image4,
    this.phone,
    this.email,
    this.views,
    this.created_user,
    this.created_at,
    this.category,
    this.subcategory,
    this.subsubcategory,
    this.sponsored,
    this.sponsored_index,});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}