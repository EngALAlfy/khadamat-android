import 'package:json_annotation/json_annotation.dart';

part 'CoinPack.g.dart';

@JsonSerializable(explicitToJson: true)
class CoinPack {
  int id;
  String name;
  String image;
  double price;
  int count;

  CoinPack({this.id, this.name, this.image, this.price, this.count});

  factory CoinPack.fromJson(Map<String, dynamic> json) =>
      _$CoinPackFromJson(json);

  Map<String, dynamic> toJson() => _$CoinPackToJson(this);
}
