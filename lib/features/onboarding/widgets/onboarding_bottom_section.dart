import 'package:centrally/core/res/strings_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:centrally/core/widgets/dot_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingBottomSection extends StatelessWidget {
  const OnboardingBottomSection({
    super.key,
    required this.currentIndex,
    required this.pageCount,
    required this.isLastPage,
    required this.onNext,
    required this.onRegister,
  });

  final int currentIndex;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p20,
      ),
      child: Column(
        children: [
          DotIndicator(currentIndex: currentIndex, count: pageCount),
          const SizedBox(height: AppSize.s24),
          ElevatedButton(
            onPressed: onNext,
            child: Text(
              isLastPage ? AppStrings.login.tr() : AppStrings.next.tr(),
            ),
          ),
          if (isLastPage) ...[
            const SizedBox(height: AppSize.s12),
            OutlinedButton(
              onPressed: onRegister,
              child: Text(AppStrings.register.tr()),
            ),
          ],
        ],
      ),
    );
  }
}
