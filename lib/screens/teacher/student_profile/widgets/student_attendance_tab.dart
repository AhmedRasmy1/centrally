import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:flutter/material.dart';

/// Student Attendance Tab — matches Figma exactly:
/// - "ملخص الحضور" section with 3 stats (معدل الحضور, حضر, غاب)
/// - "سجل الحضور" section with list of attendance records (اليوم, التاريخ, الحالة)
class StudentAttendanceTab extends StatelessWidget {
  const StudentAttendanceTab({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    // Filter attendance records that belong to this student
    final records = CenterlyMockData.attendance
        .where((a) => a.studentId == student.id)
        .toList();

    final presentCount =
        records.where((a) => a.status == AttendanceStatus.present).length;
    final absentCount =
        records.where((a) => a.status == AttendanceStatus.absent).length;
    final total = records.length;
    final attendanceRate = total == 0 ? 0 : (presentCount / total * 100).toInt();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
      children: [
        _SectionCard(
          icon: Icons.pie_chart_outline,
          title: 'ملخص الحضور',
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'غاب',
                    value: '$absentCount حصة',
                    valueColor: ColorManager.error,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: _StatBox(
                    label: 'حضر',
                    value: '$presentCount من $total حصة',
                    valueColor: ColorManager.success,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: _StatBox(
                    label: 'معدل الحضور',
                    value: '$attendanceRate%',
                    valueColor: ColorManager.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSize.s12),
        _SectionCard(
          icon: Icons.calendar_today_outlined,
          title: 'سجل الحضور',
          child: records.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
                  child: Text(
                    'لا توجد سجلات حضور',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    const _TableHeader(),
                    const Divider(height: 1, color: ColorManager.divider),
                    for (final record in records) ...[
                      _AttendanceRow(record: record),
                      if (record != records.last)
                        const Divider(height: 1, color: ColorManager.divider),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: ColorManager.divider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: AppSize.s18, color: ColorManager.primary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ColorManager.divider),
          child,
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: ColorManager.divider),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.labelSmall),
          const SizedBox(height: AppSize.s4),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(color: valueColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p14,
        vertical: AppPadding.p10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'الحالة',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'التاريخ',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'اليوم',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.record});

  final Attendance record;

  @override
  Widget build(BuildContext context) {
    final session = CenterlyMockData.sessions.firstWhere(
      (s) => s.id == record.sessionId,
      orElse: () => CenterlyMockData.sessions.first,
    );

    final (label, color, icon) = _statusInfo(record.status);
    final dayName = _arabicDayName(session.date.weekday);
    final dateStr = '${session.date.day} مايو';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p14,
        vertical: AppPadding.p12,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p12,
                  vertical: AppPadding.p4,
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
                    const SizedBox(width: AppSize.s4),
                    Icon(icon, size: AppSize.s14, color: color),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              dateStr,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dayName,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

(String, Color, IconData) _statusInfo(AttendanceStatus status) => switch (status) {
  AttendanceStatus.present => ('حاضر', ColorManager.success, Icons.check_circle_outline),
  AttendanceStatus.absent => ('غائب', ColorManager.error, Icons.cancel_outlined),
  AttendanceStatus.excused => ('معتذر', ColorManager.warning, Icons.info_outline),
  AttendanceStatus.notMarked => ('لم يُسجل', ColorManager.grey500, Icons.help_outline),
};

String _arabicDayName(int weekday) {
  const names = [
    '',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد'
  ];
  return names[weekday];
}
