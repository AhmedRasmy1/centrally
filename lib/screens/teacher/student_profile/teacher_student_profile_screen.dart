import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_academic_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_attendance_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_info_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_payments_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_profile_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Student Profile outer screen — matches Figma exactly:
/// - "ملف الطالب" app bar with back button
/// - Header with avatar, name, group, and 3 status chips
/// - 4 Tabs: بيانات الطالب, الحضور, أكاديميا, المدفوعات
class TeacherStudentProfileScreen extends StatefulWidget {
  const TeacherStudentProfileScreen({required this.student, super.key});

  final Student student;

  @override
  State<TeacherStudentProfileScreen> createState() =>
      _TeacherStudentProfileScreenState();
}

class _TeacherStudentProfileScreenState
    extends State<TeacherStudentProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: ColorManager.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          StringsManager.profileTitle.tr(),
          style: AppTextStyles.headlineSmall.copyWith(
            color: ColorManager.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          StudentProfileHeader(student: widget.student),
          const SizedBox(height: AppSize.s16),
          TabBar(
            controller: _tabController,
            labelColor: ColorManager.primary,
            unselectedLabelColor: ColorManager.textSecondary,
            indicatorColor: ColorManager.primary,
            labelStyle: AppTextStyles.titleSmall,
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: [
              Tab(text: StringsManager.profileTabInfo.tr()),
              Tab(text: StringsManager.profileTabAttendance.tr()),
              Tab(text: StringsManager.profileTabAcademic.tr()),
              Tab(text: StringsManager.profileTabPayments.tr()),
            ],
          ),
          const Divider(height: 1, color: ColorManager.divider),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StudentInfoTab(student: widget.student),
                StudentAttendanceTab(student: widget.student),
                StudentAcademicTab(student: widget.student),
                StudentPaymentsTab(student: widget.student),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
