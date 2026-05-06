class PasswordRegex {
  static final upper = RegExp(r'[A-Z]');
  static final lower = RegExp(r'[a-z]');
  static final number = RegExp(r'[0-9]');
  static final special = RegExp(r'[!@#$%^&*()_\-+=\[\]{};:"\\|,.<>\/?`~]');
}
