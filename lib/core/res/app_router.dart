import 'package:centrally/core/res/routes_manager.dart';
import 'package:centrally/features/auth/presentation/views/login_view.dart';
import 'package:centrally/features/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(child: Text('404 — Page not found')),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        // TODO: replace with RegisterView when implemented
        builder: (context, state) => const LoginView(),
      ),
    ],
  );
}
