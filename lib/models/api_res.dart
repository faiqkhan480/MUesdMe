// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'api_res.g.dart';

@JsonSerializable()
class ApiRes {
  ApiRes({
    required this.code,
    required this.message,
    required this.users,
  });

  @JsonKey(name: 'Code')
  final int? code;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'Users')
  final dynamic users;

  factory ApiRes.fromJson(Map<String, dynamic> json) => _$ApiResFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResToJson(this);

}
