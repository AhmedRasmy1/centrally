import 'package:centrally/core/constants/icons_manager.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/forgot_password_cubit.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/forgot_password_state.dart';
import 'package:centrally/features/auth/presentation/widgets/info_notice_card.dart';
import 'package:centrally/features/auth/presentation/widgets/main_title.dart';
import 'package:centrally/features/auth/presentation/widgets/primary_button.dart';
import 'package:centrally/features/auth/presentation/widgets/reset_password_icon.dart';
import 'package:centrally/features/auth/presentation/widgets/sub_title.dart';
import 'package:centrally/features/auth/presentation/widgets/titled_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
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
            children: [
              const SizedBox(height: AppSize.s24),
              const ResetPasswordIcon(),
              const SizedBox(height: AppSize.s16),

              MainTitle(title: StringsManager.forgotPasswordMainTitle.tr()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
                child: SubTitle(
                  title: StringsManager.forgotPasswordSubtitle.tr(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSize.s24),
              TitledTextField(
                controller: emailController,
                title: StringsManager.emailAddressLabel.tr(),
                hint: StringsManager.enterYourEmailHint.tr(),
                icon: IconsManager.mailIcon,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSize.s36),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            StringsManager.passwordResetCodeSent.tr(),
                          ),
                        ),
                      );
                      context.pushNamed(
                        RoutesManager.resetPasswordName,
                        pathParameters: {'email': emailController.text},
                      );
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
                              .read<ForgotPasswordCubit>()
                              .submitForgotPassword(emailController.text);
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
                      buttonLabel: StringsManager.sendCodeButton.tr(),
                      icon: Icons.arrow_forward_rounded,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSize.s16),
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: StringsManager.rememberPassword.tr(),
                    style: AppTextStyles.titleSmall,
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.goNamed(RoutesManager.loginName);
                          },
                        text: ' ${StringsManager.loginAction.tr()}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s30),

              InfoNoticeCard(
                infoText: StringsManager.forgetPasswordInfoNotice.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
