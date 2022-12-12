// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    photo: json['photo'] as String,
    method: json['method'] as String,
    phone_verified: json['phone_verified'] as int,
    api_token: json['api_token'] as String,
    items_count: json['items_count'] as int,
    points: json['points'] as int,
    created_at: json['created_at'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'phone_verified': instance.phone_verified,
      'photo': instance.photo,
      'method': instance.method,
      'api_token': instance.api_token,
      'points': instance.points,
      'items_count': instance.items_count,
      'created_at': instance.created_at,
    };
