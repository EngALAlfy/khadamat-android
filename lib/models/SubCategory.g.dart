// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
    id: json['id'] as int,
    category_id: json['category_id'] as int,
    subsubcategories: (json['subsubcategories'] as List)
        ?.map((e) => e == null
            ? null
            : SubSubCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    items_count: json['items_count'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
    created_at: json['created_at'] as String,
    created_user: json['created_user'] == null
        ? null
        : User.fromJson(json['created_user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'items_count': instance.items_count,
      'category': instance.category?.toJson(),
      'subsubcategories':
          instance.subsubcategories?.map((e) => e?.toJson())?.toList(),
      'category_id': instance.category_id,
      'created_at': instance.created_at,
      'created_user': instance.created_user?.toJson(),
    };
