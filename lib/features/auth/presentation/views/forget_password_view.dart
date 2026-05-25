import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/di/di.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/forgot_password_cubit.dart';
import 'package:centrally/features/auth/presentation/widgets/app_bar_title.dart';
import 'package:centrally/features/auth/presentation/widgets/forget_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        centerTitle: false,
        title: AppBarTitle(title: StringsManager.forgotPasswordTitle.tr()),
        backgroundColor: ColorManager.background,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => getIt<ForgotPasswordCubit>(),
          child: const ForgetPasswordViewBody(),
        ),
      ),
    );
  }
}
