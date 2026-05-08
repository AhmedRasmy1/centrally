import 'package:centrally/core/res/assets_manager.dart';
import 'package:centrally/core/res/strings_manager.dart';
import 'package:centrally/core/res/style_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p12,
          vertical: AppPadding.p8,
        ),
        child: TextButton.icon(
          onPressed: onTap,
          icon: Image.asset(
            AppAssets.skip,
            width: AppSize.s20,
            height: AppSize.s20,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
          label: Text(
            AppStrings.skip.tr(),
            style: AppTextStyles.caption,
          ),
        ),
      ),
    );
  }
}
