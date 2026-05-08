abstract final class AppStrings {
  // General
  static const String appName = 'app_name';
  static const String welcome = 'welcome';

  // Onboarding
  static const String onboardingTitle1 = 'onboarding_title_1';
  static const String onboardingDesc1 = 'onboarding_desc_1';
  static const String onboardingTitle2 = 'onboarding_title_2';
  static const String onboardingDesc2 = 'onboarding_desc_2';
  static const String onboardingTitle3 = 'onboarding_title_3';
  static const String onboardingDesc3 = 'onboarding_desc_3';
  static const String skip = 'skip';
  static const String next = 'next';

  // Auth
  static const String login = 'login';
  static const String register = 'register';
  static const String email = 'email';
  static const String password = 'password';
  static const String forgotPassword = 'forgot_password';
}

// Legacy alias — prefer AppStrings in new code.
typedef StringsManager = AppStrings;
