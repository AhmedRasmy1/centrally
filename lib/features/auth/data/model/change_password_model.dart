import 'package:json_annotation/json_annotation.dart';

part 'change_password_model.g.dart';

@JsonSerializable()
class ChangePasswordModel {
  final String currentPassword;
  final String newPassword;

  ChangePasswordModel({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChangePasswordModelToJson(this);
}