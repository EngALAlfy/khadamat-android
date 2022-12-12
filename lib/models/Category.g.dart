// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    items_count: json['items_count'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    subcategories: (json['subcategories'] as List)
        ?.map((e) =>
            e == null ? null : SubCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    created_at: json['created_at'] as String,
    created_user: json['created_user'] == null
        ? null
        : User.fromJson(json['created_user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'items_count': instance.items_count,
      'created_at': instance.created_at,
      'subcategories':
          instance.subcategories?.map((e) => e?.toJson())?.toList(),
      'created_user': instance.created_user?.toJson(),
    };
