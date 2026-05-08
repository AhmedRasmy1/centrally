import 'package:centrally/core/res/color_manager.dart';
import 'package:centrally/core/res/style_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:centrally/features/onboarding/onboarding_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({super.key, required this.model});

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.sizeOf(context).height * 0.32;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            model.image,
            height: imageHeight,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => SizedBox(
              height: imageHeight,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.s40),
          SizedBox(
            width: double.infinity,
            child: Text(
              model.titleKey.tr(),
              textAlign: TextAlign.right,
              style: AppTextStyles.headingLarge,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          SizedBox(
            width: double.infinity,
            child: Text(
              model.descriptionKey.tr(),
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
