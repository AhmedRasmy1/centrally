import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/constants/icons_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/features/auth/presentation/widgets/info_notice_card.dart';
import 'package:centrally/features/auth/presentation/widgets/main_title.dart';
import 'package:centrally/features/auth/presentation/widgets/password_titled_text_field.dart';
import 'package:centrally/features/auth/presentation/widgets/primary_button.dart';
import 'package:centrally/features/auth/presentation/widgets/step_indicator.dart';
import 'package:centrally/features/auth/presentation/widgets/sub_title.dart';
import 'package:centrally/features/auth/presentation/widgets/titled_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:centrally/core/router/routes_manager.dart';

class CreateAdminViewBody extends StatefulWidget {
  const CreateAdminViewBody({super.key});

  @override
  State<CreateAdminViewBody> createState() => _CreateAdminViewBodyState();
}

class _CreateAdminViewBodyState extends State<CreateAdminViewBody> {
  final adminNameController = TextEditingController();

  final adminEmailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    adminNameController.dispose();
    adminEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s64),
                  child: StepIndicator(currentStep: 2),
                ),
              ),
              MainTitle(title: StringsManager.createAdminTitle.tr()),
              SubTitle(title: StringsManager.createAdminSubtitle.tr()),
              const SizedBox(height: AppSize.s24),
              TitledTextField(
                controller: adminNameController,
                title: StringsManager.adminNameLabel.tr(),
                hint: StringsManager.adminNameHint.tr(),
                icon: IconsManager.userIcon,
                keyboardType: TextInputType.name,
              ),
              TitledTextField(
                controller: adminEmailController,
                title: StringsManager.adminEmailLabel.tr(),
                hint: StringsManager.adminEmailHint.tr(),
                icon: IconsManager.mailIcon,
                keyboardType: TextInputType.emailAddress,
              ),
              PasswordTitledTextField(
                controller: passwordController,
                title: StringsManager.adminPasswordLabel.tr(),
                hint: StringsManager.adminPasswordHint.tr(),
                icon: IconsManager.lockIcon,
                isPassword: true,
                showValidationChecks: true,
              ),
              const SizedBox(height: AppSize.s16),
              PasswordTitledTextField(
                controller: confirmPasswordController,
                title: StringsManager.adminConfirmPasswordLabel.tr(),
                hint: StringsManager.adminPasswordHint.tr(),
                icon: IconsManager.lockIcon,
                isConfirmPassword: true,
                matchController: passwordController,
              ),
              const SizedBox(height: AppSize.s8),
              const InfoNoticeCard(),
              const SizedBox(height: AppSize.s32),
              PrimaryButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.goNamed(RoutesManager.registerSuccessName);
                  }
                },
                buttonLabel: StringsManager.createAccountButton.tr(),
              ),
              const SizedBox(height: AppSize.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringsManager.haveAccount.tr(),
                    style: AppTextStyles.bodySemiBold,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(RoutesManager.loginName);
                    },
                    child: Text(
                      StringsManager.loginAction.tr(),
                      style: AppTextStyles.bodySemiBold.copyWith(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s16),
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: StringsManager.termsAgreement.tr(),
                    style: AppTextStyles.labelSmall,
                    children: [
                      TextSpan(
                        text: StringsManager.privacyPolicy.tr(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: ColorManager.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s32),
            ],
          ),
        ),
      ),
    );
  }
}
