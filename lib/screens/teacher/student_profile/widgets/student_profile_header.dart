import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/teacher_shared.dart';
import 'package:flutter/material.dart';

/// Student Profile Header — matches Figma exactly:
/// - Avatar on left side (in RTL, leading is right, trailing is left)
/// - Name and group on the right side
/// - Three chips: "المستوى الأول", "نسبة الحضور 85%", "الحساب مدفوع"
class StudentProfileHeader extends StatelessWidget {
  const StudentProfileHeader({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final group = CenterlyMockData.groupById(student.groupId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(student.name, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSize.s4),
                  Text(group.name, style: AppTextStyles.labelSmall),
                ],
              ),
              const SizedBox(width: AppSize.s16),
              const StudentAvatar(radius: AppSize.s32),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Scroll from right to left if needed
            child: Row(
              children: [
                const _StatusChip(
                  label: 'الحساب مدفوع',
                  icon: Icons.check_circle_outline,
                  color: ColorManager.success,
                ),
                const SizedBox(width: AppSize.s8),
                const _StatusChip(
                  label: 'نسبة الحضور 85%',
                  color: ColorManager.primary,
                ),
                const SizedBox(width: AppSize.s8),
                const _StatusChip(
                  label: 'المستوى الأول',
                  color: ColorManager.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
          if (icon != null) ...[
            const SizedBox(width: AppSize.s6),
            Icon(icon, size: AppSize.s14, color: color),
          ],
        ],
      ),
    );
  }
}
