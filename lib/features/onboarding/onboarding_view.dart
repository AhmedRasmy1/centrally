import 'package:centrally/core/res/assets_manager.dart';
import 'package:centrally/core/res/routes_manager.dart';
import 'package:centrally/core/res/strings_manager.dart';
import 'package:centrally/features/onboarding/onboarding_model.dart';
import 'package:centrally/features/onboarding/widgets/onboarding_bottom_section.dart';
import 'package:centrally/features/onboarding/widgets/onboarding_page_content.dart';
import 'package:centrally/features/onboarding/widgets/onboarding_skip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingModel> _pages = [
    OnboardingModel(
      image: AppAssets.onboarding1,
      titleKey: AppStrings.onboardingTitle1,
      descriptionKey: AppStrings.onboardingDesc1,
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      titleKey: AppStrings.onboardingTitle2,
      descriptionKey: AppStrings.onboardingDesc2,
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      titleKey: AppStrings.onboardingTitle3,
      descriptionKey: AppStrings.onboardingDesc3,
    ),
  ];

  bool get _isLastPage => _currentIndex == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _removeSplash();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _removeSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  void _onNextPressed() {
    if (_isLastPage) {
      context.pushReplacement(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingSkipButton(
              onTap: () => context.pushReplacement(AppRoutes.login),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentIndex = index),
                itemBuilder: (context, index) =>
                    OnboardingPageContent(model: _pages[index]),
              ),
            ),
            OnboardingBottomSection(
              currentIndex: _currentIndex,
              pageCount: _pages.length,
              isLastPage: _isLastPage,
              onNext: _onNextPressed,
              onRegister: () => context.go(AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
