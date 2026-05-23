import 'package:centrally/features/auth/domain/entities/logout_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'logout_model.g.dart';

@JsonSerializable()
class LogoutModel {
  final String message;

  LogoutModel({required this.message});
  factory LogoutModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutModelToJson(this);

  LogoutEntity toLogoutEntity() {
    return LogoutEntity(message: message);
  }
}
