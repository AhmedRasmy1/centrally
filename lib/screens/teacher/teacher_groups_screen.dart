import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/teacher_shared.dart';
import 'package:flutter/material.dart';

/// Groups screen — matches Figma:
/// - White AppBar "المجموعات" centered
/// - Search field
/// - Grade level header with left blue border accent
/// - Group cards: name + schedule + capacity + next session grey bar
class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({super.key});

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredGroups = CenterlyMockData.groups.where((g) {
      final text =
          '${g.name} ${g.subjectName} ${g.gradeLevelName}'.toLowerCase();
      return text.contains(_query.trim().toLowerCase());
    }).toList();

    final gradeLevels = filteredGroups
        .map((g) => g.gradeLevelName)
        .toSet()
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorManager.surface,
          title: Text('المجموعات', style: AppTextStyles.headlineSmall),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.p16,
                AppPadding.p12,
                AppPadding.p16,
                AppPadding.p8,
              ),
              child: TeacherSearchField(
                hint: 'ابحث عن مجموعة أو طالب',
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: filteredGroups.isEmpty
                  ? const TeacherEmptyState(
                      title: 'لا توجد مجموعات',
                      subtitle: 'لم نجد نتيجة مطابقة لبحثك.',
                      icon: Icons.groups_2_outlined,
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p16,
                        vertical: AppPadding.p8,
                      ),
                      children: [
                        for (final grade in gradeLevels) ...[
                          _GradeLevelHeader(label: grade),
                          const SizedBox(height: AppSize.s12),
                          for (final group in filteredGroups.where(
                            (g) => g.gradeLevelName == grade,
                          )) ...[
                            _GroupCard(group: group),
                            const SizedBox(height: AppSize.s10),
                          ],
                          const SizedBox(height: AppSize.s8),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Grade Level Header with left blue accent ──────────────────────────────────

class _GradeLevelHeader extends StatelessWidget {
  const _GradeLevelHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.titleMedium),
          ),
          Container(
            width: AppSize.s4,
            decoration: const BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppRadius.r4),
                bottomRight: Radius.circular(AppRadius.r4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Group Card ────────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return TeacherCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.name, style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSize.s10),
          _InfoLine(
            icon: Icons.calendar_today_outlined,
            text: group.scheduleLabel,
          ),
          const SizedBox(height: AppSize.s6),
          _InfoLine(
            icon: Icons.people_outline,
            text: '${group.capacity} طالب',
          ),
          const SizedBox(height: AppSize.s12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p10,
            ),
            decoration: BoxDecoration(
              color: ColorManager.grey200,
              borderRadius: BorderRadius.circular(AppRadius.r8),
            ),
            child: Row(
              children: [
                Text(
                  'الحصة القادمة',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: ColorManager.primary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppSize.s16,
                  color: ColorManager.grey500,
                ),
                const SizedBox(width: AppSize.s4),
                Text(
                  _formatDate(group.nextSessionAt),
                  style: AppTextStyles.labelSmall,
                ),
                const SizedBox(width: AppSize.s12),
                const Icon(
                  Icons.schedule_outlined,
                  size: AppSize.s16,
                  color: ColorManager.grey500,
                ),
                const SizedBox(width: AppSize.s4),
                Text(
                  _formatTimeShort(group.nextSessionAt),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSize.s16, color: ColorManager.grey500),
        const SizedBox(width: AppSize.s8),
        Text(text, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

String _formatDate(DateTime dt) {
  const months = [
    '',
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return '${dt.day} ${months[dt.month]}';
}

String _formatTimeShort(DateTime dt) {
  final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
  final suffix = dt.hour >= 12 ? 'م' : 'ص';
  return '${hour.toString().padLeft(2, '0')}:00 $suffix';
}
