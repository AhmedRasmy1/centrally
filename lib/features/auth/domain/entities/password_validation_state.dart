class PasswordValidationState {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecial;

  const PasswordValidationState({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecial,
  });

  bool get isValid =>
      hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecial;
}
