// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    id: json['id'] as int,
    name: json['name'] as String,
    desc: json['desc'] as String,
    image: json['image'] as String,
    image1: json['image1'] as String,
    image2: json['image2'] as String,
    image3: json['image3'] as String,
    archived: json['archived'] as int,
    image4: json['image4'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    views: json['views'] as int,
    created_user: json['created_user'] == null
        ? null
        : User.fromJson(json['created_user'] as Map<String, dynamic>),
    created_at: json['created_at'] as String,
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
    subcategory: json['subcategory'] == null
        ? null
        : SubCategory.fromJson(json['subcategory'] as Map<String, dynamic>),
    subsubcategory: json['subsubcategory'] == null
        ? null
        : SubSubCategory.fromJson(
            json['subsubcategory'] as Map<String, dynamic>),
    sponsored: json['sponsored'] as int,
    sponsored_index: json['sponsored_index'] as int,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'image': instance.image,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'image4': instance.image4,
      'phone': instance.phone,
      'email': instance.email,
      'created_user': instance.created_user?.toJson(),
      'created_at': instance.created_at,
      'category': instance.category?.toJson(),
      'subcategory': instance.subcategory?.toJson(),
      'subsubcategory': instance.subsubcategory?.toJson(),
      'views': instance.views,
      'sponsored': instance.sponsored,
      'archived': instance.archived,
      'sponsored_index': instance.sponsored_index,
    };
