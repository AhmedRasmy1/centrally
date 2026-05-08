import 'package:centrally/core/res/color_manager.dart';
import 'package:centrally/core/res/style_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:centrally/features/auth/presentation/widgets/features_card.dart';
import 'package:centrally/features/auth/presentation/widgets/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/core/res/strings_manager.dart';
import 'package:flutter/material.dart';

class RegisterSuccessViewBody extends StatelessWidget {
  const RegisterSuccessViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            const SizedBox(height: AppSize.s40),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.success.withValues(alpha: 0.2),
                    blurRadius: AppRadius.r16,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: AppRadius.r42,
                backgroundColor: ColorManager.success,
                child: Icon(Icons.check_rounded, size: AppSize.s50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
              child: Text(
                StringsManager.registerSuccessTitle.tr(),
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              StringsManager.registerSuccessSubtitle.tr(),
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSize.s40),
            const FeaturesCard(),
            const SizedBox(height: AppSize.s100),
            PrimaryButton(
              onPressed: () {},
              buttonLabel: StringsManager.goToDashboard.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
