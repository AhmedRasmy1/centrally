import 'package:centrally/core/res/color_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:flutter/material.dart';

class StepCircleIndicator extends StatelessWidget {
  const StepCircleIndicator({
    super.key,
    required this.isActive,
    required this.isCompleted,
    required this.number,
  });
  final bool isActive;
  final bool isCompleted;
  final int number;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppRadius.r16,
      backgroundColor: (isActive || isCompleted)
          ? ColorManager.primary
          : ColorManager.primary.withOpacity(0.15),
      child: isCompleted
          ? const Icon(
              Icons.check,
              color: ColorManager.white,
              size: AppSize.s16,
            )
          : Text(
              '$number',
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : ColorManager.primary.withOpacity(0.5),
              ),
            ),
    );
  }
}
