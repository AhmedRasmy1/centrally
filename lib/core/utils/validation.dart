import 'package:centrally/core/res/strings_manager.dart';
import 'package:centrally/core/utils/password_regex.dart';
import 'package:centrally/features/auth/domain/entities/password_validation_state.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthValidator {
  // ================= EMAIL =================
  static String? validateEmail(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return StringsManager.validationEmailRequired.tr();
    }

    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegex.hasMatch(v.trim())) {
      return StringsManager.validationEmailInvalid.tr();
    }

    return null;
  }

  // ================= PHONE =================
  static String? validatePhone(String value) {
    if (value.trim().isEmpty) {
      return StringsManager.validationPhoneRequired.tr();
    }

    // Egyptian phone (11 digits)
    final phoneRegex = RegExp(r'^01[0-9]{9}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return StringsManager.validationPhoneInvalid.tr();
    }

    return null;
  }

  // ================= PASSWORD =================
  static String? validatePassword(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return StringsManager.validationPasswordRequired.tr();
    }

    if (v.length < 8) {
      return StringsManager.passwordMin.tr();
    }

    if (!PasswordRegex.upper.hasMatch(v)) {
      return StringsManager.passwordUpperCase.tr();
    }

    if (!PasswordRegex.lower.hasMatch(v)) {
      return StringsManager.passwordLowerCase.tr();
    }

    if (!PasswordRegex.number.hasMatch(v)) {
      return StringsManager.passwordNumber.tr();
    }

    if (!PasswordRegex.special.hasMatch(v)) {
      return StringsManager.passwordSpecial.tr();
    }

    return null;
  }

  //========== password chech state ====================
  static PasswordValidationState validatePasswordLive(String value) {
    return PasswordValidationState(
      hasMinLength: value.length >= 8,
      hasUppercase: PasswordRegex.upper.hasMatch(value),
      hasLowercase: PasswordRegex.lower.hasMatch(value),
      hasNumber: PasswordRegex.number.hasMatch(value),
      hasSpecial: PasswordRegex.special.hasMatch(value),
    );
  }
}
