import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:flutter/material.dart';

class ResetPasswordIcon extends StatelessWidget {
  const ResetPasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Card(
          margin: EdgeInsets.all(8),
          elevation: 0,
          color: ColorManager.primaryBright,
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p32),
            child: Icon(
              Icons.lock_reset_rounded,
              color: ColorManager.primary,
              size: AppSize.s50,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            radius: 21,
            backgroundColor: ColorManager.white,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ColorManager.primaryDark,
              child: Icon(
                size: AppSize.s20,
                Icons.mail_outline_outlined,
                color: ColorManager.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
