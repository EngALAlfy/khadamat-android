// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoinPack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinPack _$CoinPackFromJson(Map<String, dynamic> json) {
  return CoinPack(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    price: (json['price'] as num)?.toDouble(),
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$CoinPackToJson(CoinPack instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'count': instance.count,
    };
