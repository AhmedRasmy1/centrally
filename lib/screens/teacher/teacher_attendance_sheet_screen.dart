import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/student_profile/teacher_student_profile_screen.dart';
import 'package:centrally/screens/teacher/teacher_shared.dart';
import 'package:flutter/material.dart';

/// Attendance Sheet — read-only for Teacher.
/// Matches Figma exactly:
/// - AppBar: "كشف الحضور" + back arrow + "للعرض فقط" chip
/// - Header card with group info
/// - Filter chips (الكل / حاضر / غائب / معتذر) with counts
/// - Search field
/// - Student list with avatar + name + group + status chip on LEFT
/// - Sticky bottom banner "يتولى السكرتير تسجيل الحضور"
class TeacherAttendanceSheetScreen extends StatefulWidget {
  const TeacherAttendanceSheetScreen({required this.session, super.key});

  final Session session;

  @override
  State<TeacherAttendanceSheetScreen> createState() =>
      _TeacherAttendanceSheetScreenState();
}

class _TeacherAttendanceSheetScreenState
    extends State<TeacherAttendanceSheetScreen> {
  AttendanceStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allRecords =
        CenterlyMockData.attendanceForSession(widget.session.id);

    final counts = {
      null: allRecords.length,
      AttendanceStatus.present:
          allRecords.where((a) => a.status == AttendanceStatus.present).length,
      AttendanceStatus.absent:
          allRecords.where((a) => a.status == AttendanceStatus.absent).length,
      AttendanceStatus.excused:
          allRecords.where((a) => a.status == AttendanceStatus.excused).length,
    };

    final filtered = allRecords.where((item) {
      final student = CenterlyMockData.studentById(item.studentId);
      final matchesFilter =
          _filter == null || item.status == _filter;
      final matchesQuery =
          _query.isEmpty || student.name.contains(_query.trim());
      return matchesFilter && matchesQuery;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          leading: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('كشف الحضور', style: AppTextStyles.headlineSmall),
          actions: [
            Container(
              margin: const EdgeInsetsDirectional.only(end: AppPadding.p16),
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p10,
                vertical: AppPadding.p4,
              ),
              decoration: BoxDecoration(
                color: ColorManager.grey200,
                borderRadius:
                    BorderRadius.circular(AppRadius.circular),
              ),
              child: Text(
                'للعرض فقط',
                style: AppTextStyles.labelSmall,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.p16),
                children: [
                  _SessionCard(session: widget.session),
                  const SizedBox(height: AppSize.s16),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'الكل ${counts[null]}',
                          selected: _filter == null,
                          onTap: () => setState(() => _filter = null),
                        ),
                        const SizedBox(width: AppSize.s8),
                        _FilterChip(
                          label: 'حاضر ${counts[AttendanceStatus.present]}',
                          selected: _filter == AttendanceStatus.present,
                          onTap: () => setState(
                            () => _filter = AttendanceStatus.present,
                          ),
                        ),
                        const SizedBox(width: AppSize.s8),
                        _FilterChip(
                          label: 'غائب ${counts[AttendanceStatus.absent]}',
                          selected: _filter == AttendanceStatus.absent,
                          onTap: () => setState(
                            () => _filter = AttendanceStatus.absent,
                          ),
                        ),
                        const SizedBox(width: AppSize.s8),
                        _FilterChip(
                          label: 'معتذر ${counts[AttendanceStatus.excused]}',
                          selected: _filter == AttendanceStatus.excused,
                          onTap: () => setState(
                            () => _filter = AttendanceStatus.excused,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  TeacherSearchField(
                    hint: 'ابحث عن الطالب',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: AppSize.s12),
                  if (filtered.isEmpty)
                    const TeacherEmptyState(
                      title: 'هذا الطالب غير موجود',
                      subtitle: 'جرّب اسمًا آخر أو غيّر الفلتر.',
                      icon: Icons.search_off_outlined,
                    )
                  else
                    for (final item in filtered) ...[
                      _StudentRow(
                        attendance: item,
                        onTap: () {
                          final student = CenterlyMockData.studentById(
                            item.studentId,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => TeacherStudentProfileScreen(
                                student: student,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: AppSize.s1),
                    ],
                ],
              ),
            ),
            // Sticky bottom banner
            Container(
              width: double.infinity,
              color: ColorManager.grey200,
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p14,
                horizontal: AppPadding.p16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: AppSize.s16,
                    color: ColorManager.grey500,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    'يتولى السكرتير تسجيل الحضور',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: ColorManager.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Session info card ─────────────────────────────────────────────────────────

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final group = CenterlyMockData.groupById(session.groupId);
    return TeacherCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${group.name} - ${group.subjectName}',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(width: AppSize.s8),
                    Text(
                      '${session.expectedStudentsCount ~/ 10}ث',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s6),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: AppSize.s14,
                      color: ColorManager.grey500,
                    ),
                    const SizedBox(width: AppSize.s4),
                    Text('11:00 صباحًا - 12:00 مساءً',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
                const SizedBox(height: AppSize.s4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: AppSize.s14,
                      color: ColorManager.grey500,
                    ),
                    const SizedBox(width: AppSize.s4),
                    Text('السبت، 19 أبريل 2025',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: AppSize.s36,
            height: AppSize.s36,
            decoration: BoxDecoration(
              color: ColorManager.primaryBright,
              borderRadius: BorderRadius.circular(AppRadius.r8),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: ColorManager.primary,
              size: AppSize.s20,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p8,
        ),
        decoration: BoxDecoration(
          color: selected ? ColorManager.primary : ColorManager.grey200,
          borderRadius: BorderRadius.circular(AppRadius.circular),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color:
                selected ? ColorManager.white : ColorManager.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Student row ───────────────────────────────────────────────────────────────

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.attendance, required this.onTap});

  final Attendance attendance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final student = CenterlyMockData.studentById(attendance.studentId);
    final group = CenterlyMockData.groupById(student.groupId);
    final color = attendanceColor(attendance.status);
    final label = attendanceLabel(attendance.status);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
        child: Row(
          children: [
            // Status chip on right (RTL — leading in LTR terms = leftmost)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p10,
                vertical: AppPadding.p4,
              ),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius:
                    BorderRadius.circular(AppRadius.circular),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(student.name, style: AppTextStyles.titleSmall),
                  Text(group.name, style: AppTextStyles.labelSmall),
                ],
              ),
            ),
            const SizedBox(width: AppSize.s12),
            const StudentAvatar(radius: AppSize.s18),
          ],
        ),
      ),
    );
  }
}
