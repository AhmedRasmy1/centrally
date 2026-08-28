import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.blueHeader = false,
    this.padding = const EdgeInsets.all(AppPadding.p16),
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool blueHeader;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            blueHeader ? ColorManager.primary : ColorManager.background,
        foregroundColor:
            blueHeader ? ColorManager.white : ColorManager.textPrimary,
        title: Text(title),
        actions: actions,
      ),
      body: Padding(padding: padding, child: child),
    );
  }
}

class TeacherSectionTitle extends StatelessWidget {
  const TeacherSectionTitle({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.headlineSmall)),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.chevron_left, size: AppSize.s18),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}

class TeacherCard extends StatelessWidget {
  const TeacherCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppPadding.p16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: ColorManager.divider),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class TeacherStatCard extends StatelessWidget {
  const TeacherStatCard({
    required this.title,
    required this.value,
    required this.color,
    super.key,
    this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TeacherCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: AppSize.s18),
                const SizedBox(width: AppSize.s4),
              ],
              Text(
                value,
                style: AppTextStyles.headlineLarge.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s4),
          Text(
            title,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TeacherSearchField extends StatelessWidget {
  const TeacherSearchField({
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: ColorManager.grey500),
        fillColor: ColorManager.grey200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class TeacherEmptyState extends StatelessWidget {
  const TeacherEmptyState({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
  });

  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p32),
      child: Column(
        children: [
          CircleAvatar(
            radius: AppSize.s40,
            backgroundColor: ColorManager.primaryBright,
            child: Icon(
              icon ?? Icons.event_busy_outlined,
              color: ColorManager.primary,
              size: AppSize.s40,
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Text(
            title,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TeacherSessionCard extends StatelessWidget {
  const TeacherSessionCard({
    required this.session,
    required this.onTap,
    super.key,
    this.highlight = false,
  });

  final Session session;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final group = CenterlyMockData.groupById(session.groupId);
    final presentCount = CenterlyMockData.attendanceForSession(session.id)
        .where((item) => item.status == AttendanceStatus.present)
        .length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: TeacherCard(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: Row(
          children: [
            Container(
              width: AppSize.s48,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
              decoration: BoxDecoration(
                color: highlight ? ColorManager.primary : ColorManager.grey200,
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Text(
                formatTime(session.startTime),
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  color: highlight
                      ? ColorManager.white
                      : ColorManager.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${group.name} - ${group.subjectName}',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    '$presentCount/${session.expectedStudentsCount}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: ColorManager.success,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              StringsManager.sessionDurationLabel.tr(
                namedArgs: {
                  'count': '${session.expectedStudentsCount ~/ 10}',
                },
              ),
              style: AppTextStyles.labelLarge.copyWith(
                color: ColorManager.primary,
              ),
            ),
            const SizedBox(width: AppSize.s8),
            const Icon(Icons.chevron_left, color: ColorManager.grey500),
          ],
        ),
      ),
    );
  }
}

class TeacherStatusChip extends StatelessWidget {
  const TeacherStatusChip({
    required this.label,
    required this.color,
    super.key,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      selectedColor: color,
      backgroundColor: ColorManager.grey200,
      labelStyle: AppTextStyles.labelSmall.copyWith(
        color: selected ? ColorManager.white : ColorManager.textPrimary,
      ),
      side: BorderSide(color: selected ? color : ColorManager.divider),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
    );
  }
}

class StudentAvatar extends StatelessWidget {
  const StudentAvatar({super.key, this.radius = AppSize.s18});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: ColorManager.primaryBright,
      child: Icon(Icons.person, color: ColorManager.primary, size: radius),
    );
  }
}

String formatTime(DateTime value) {
  final hour = value.hour > 12 ? value.hour - 12 : value.hour;
  final suffix = value.hour >= 12 ? 'م' : 'ص';
  return '${hour.toString().padLeft(2, '0')}:00\n$suffix';
}

String attendanceLabel(AttendanceStatus status) => switch (status) {
  AttendanceStatus.present => StringsManager.attendancePresent.tr(),
  AttendanceStatus.absent => StringsManager.attendanceAbsent.tr(),
  AttendanceStatus.excused => StringsManager.attendanceExcused.tr(),
  AttendanceStatus.notMarked => StringsManager.attendanceNotMarked.tr(),
};

Color attendanceColor(AttendanceStatus status) => switch (status) {
  AttendanceStatus.present => ColorManager.success,
  AttendanceStatus.absent => ColorManager.error,
  AttendanceStatus.excused => ColorManager.warning,
  AttendanceStatus.notMarked => ColorManager.grey500,
};
