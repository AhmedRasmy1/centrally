import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.activeColor = ColorManager.primary,
    this.inactiveColor = ColorManager.grey300,
  });

  final int currentIndex;
  final int count;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: AppSize.s8,
      width: isActive ? AppSize.s24 : AppSize.s8,
      margin: const EdgeInsets.symmetric(horizontal: AppSize.s4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.circular),
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}
