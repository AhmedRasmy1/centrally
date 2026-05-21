import 'package:centrally/features/auth/domain/entities/login_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  String? accessToken;
  String? refreshToken;
  String? role;
  String? teacherId;

  LoginModel({this.accessToken, this.refreshToken, this.role, this.teacherId});
  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  LoginEntity toLoginEntity() {
    return LoginEntity(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      role: role ?? '',
      teacherId: teacherId ?? '',
    );
  }
}
