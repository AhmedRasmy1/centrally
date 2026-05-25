import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/utils/cached_data_shared_preferences.dart';
import 'package:centrally/features/auth/presentation/views/create_admin_view.dart';
import 'package:centrally/features/auth/presentation/views/create_center_view.dart';
import 'package:centrally/features/auth/presentation/views/forget_password_view.dart';
import 'package:centrally/features/auth/presentation/views/login_view.dart';
import 'package:centrally/features/auth/presentation/views/register_success_view.dart';
import 'package:centrally/features/auth/presentation/views/reset_password_view.dart';
import 'package:centrally/features/home/home_demo.dart';
import 'package:centrally/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:centrally/features/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutesManager.splashPath,
    redirect: _authRedirect,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
    routes: [
      GoRoute(
        path: RoutesManager.splashPath,
        name: RoutesManager.splashName,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: RoutesManager.onboardingPath,
        name: RoutesManager.onboardingName,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: RoutesManager.loginPath,
        name: RoutesManager.loginName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutesManager.createCenterPath,
        name: RoutesManager.createCenterName,
        builder: (context, state) => const CreateCenterView(),
      ),
      GoRoute(
        path: RoutesManager.createAdminPath,
        name: RoutesManager.createAdminName,
        builder: (context, state) => const CreateAdminView(),
      ),
      GoRoute(
        path: RoutesManager.registerSuccessPath,
        name: RoutesManager.registerSuccessName,
        builder: (context, state) => const RegisterSuccessView(),
      ),
      GoRoute(
        path: RoutesManager.homePath,
        name: RoutesManager.homeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutesManager.forgetPasswordPath,
        name: RoutesManager.forgetPasswordName,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: RoutesManager.resetPasswordPath,
        name: RoutesManager.resetPasswordName,
        builder: (context, state) {
          final email = state.pathParameters['email'] ?? '';
          return ResetPasswordView(email: email);
        },
      ),
    ],
  );

  static String? _authRedirect(BuildContext context, GoRouterState state) {
    final token =
        CacheService.getData(key: CacheConstants.userToken) as String?;
    final isAuthenticated = token != null && token.isNotEmpty;
    final isSplash = state.matchedLocation == RoutesManager.splashPath;

    if (isSplash) return null;

    const publicRoutes = [
      RoutesManager.onboardingPath,
      RoutesManager.loginPath,
      RoutesManager.forgetPasswordPath,
      RoutesManager.resetPasswordPath,
      RoutesManager.createCenterPath,
      RoutesManager.createAdminPath,
      RoutesManager.registerSuccessPath,
    ];

    if (!isAuthenticated && !publicRoutes.contains(state.matchedLocation)) {
      if (state.matchedLocation.startsWith('/reset_password')) {
        return null;
      }
      return RoutesManager.loginPath;
    }
    return null;
  }
}
