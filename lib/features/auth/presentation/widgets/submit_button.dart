import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          disabledBackgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: AppSize.s20,
                  height: AppSize.s20,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSize.s2,
                    color: ColorManager.white,
                  ),
                )
              : Text(
                  StringsManager.loginSubmit.tr(),
                  key: const ValueKey('text'),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: ColorManager.white,
                  ),
                ),
        ),
      ),
    );
  }
}
