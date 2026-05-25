import 'package:centrally/core/di/di.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/features/auth/presentation/view_models/cubit/reset_password_cubit.dart';
import 'package:centrally/features/auth/presentation/widgets/app_bar_title.dart';
import 'package:centrally/features/auth/presentation/widgets/reset_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/core/constants/strings_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        centerTitle: false,
        title: AppBarTitle(title: StringsManager.securityTitle.tr()),
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
          create: (context) => getIt<ResetPasswordCubit>(),
          child: ResetPasswordViewBody(email: email),
        ),
      ),
    );
  }
}
