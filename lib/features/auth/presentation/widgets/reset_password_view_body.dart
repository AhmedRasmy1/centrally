import 'package:centrally/core/constants/icons_manager.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/reset_password_cubit.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/reset_password_state.dart';
import 'package:centrally/features/auth/presentation/widgets/info_notice_card.dart';
import 'package:centrally/features/auth/presentation/widgets/main_title.dart';
import 'package:centrally/features/auth/presentation/widgets/password_titled_text_field.dart';
import 'package:centrally/features/auth/presentation/widgets/primary_button.dart';
import 'package:centrally/features/auth/presentation/widgets/sub_title.dart';
import 'package:centrally/features/auth/presentation/widgets/titled_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordViewBody extends StatefulWidget {
  const ResetPasswordViewBody({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainTitle(title: StringsManager.createNewPasswordTitle.tr()),
              SubTitle(
                title: StringsManager.createNewPasswordSubtitle.tr(),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppSize.s24),
              TitledTextField(
                controller: codeController,
                title: StringsManager.verificationCodeLabel.tr(),
                hint: StringsManager.passwordResetCodeHint.tr(),
                icon: IconsManager.verificationIcon,
                keyboardType: TextInputType.number,
              ),
              PasswordTitledTextField(
                controller: passwordController,
                title: StringsManager.newPasswordLabel.tr(),
                hint: StringsManager.newPasswordHint.tr(),
                icon: IconsManager.lockIcon,
                showValidationChecks: true,
                isPassword: true,
              ),
              const SizedBox(height: AppSize.s16),
              PasswordTitledTextField(
                controller: confirmPasswordController,
                title: StringsManager.confirmPasswordLabel.tr(),
                hint: StringsManager.confirmNewPasswordHint.tr(),
                icon: IconsManager.lockIcon,
                isConfirmPassword: true,
                matchController: passwordController,
              ),
              const SizedBox(height: AppSize.s8),
              InfoNoticeCard(
                infoText: StringsManager.resetPasswordInfoNotice.tr(),
              ),
              const SizedBox(height: AppSize.s50),

              BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            StringsManager.passwordResetSuccess.tr(),
                          ),
                        ),
                      );
                      context.goNamed(RoutesManager.loginName);
                    },
                    failure: (message) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () => PrimaryButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context
                              .read<ResetPasswordCubit>()
                              .submitResetPassword(
                                code: codeController.text,
                                newPassword: passwordController.text,
                                email: widget.email,
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                StringsManager.enterValidEmail.tr(),
                              ),
                            ),
                          );
                        }
                      },
                      buttonLabel: StringsManager.resetPasswordButton.tr(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
