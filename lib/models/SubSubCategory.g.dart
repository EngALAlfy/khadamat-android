// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubSubCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubSubCategory _$SubSubCategoryFromJson(Map<String, dynamic> json) {
  return SubSubCategory(
    id: json['id'] as int,
    category_id: json['category_id'] as String,
    items_count: json['items_count'] as int,
    name: json['name'] as String,
    subcategory_id: json['subcategory_id'] as String,
    subcategory: json['subcategory'] == null
        ? null
        : SubCategory.fromJson(json['subcategory'] as Map<String, dynamic>),
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

Map<String, dynamic> _$SubSubCategoryToJson(SubSubCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'items_count': instance.items_count,
      'category': instance.category?.toJson(),
      'subcategory': instance.subcategory?.toJson(),
      'category_id': instance.category_id,
      'subcategory_id': instance.subcategory_id,
      'created_at': instance.created_at,
      'created_user': instance.created_user?.toJson(),
    };
