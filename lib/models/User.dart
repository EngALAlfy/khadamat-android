import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable(explicitToJson: true)
class User{
  int id;
  String name;
  String username;
  String email;
  String phone;
  int phone_verified;
  String photo;
  String method;
  String api_token;
  int points;
  int items_count;
  String created_at;

  User({this.id, this.name, this.username, this.email, this.phone, this.photo,
      this.method,this.phone_verified, this.api_token,this.items_count, this.points, this.created_at});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}