import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_academic_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_attendance_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_info_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_payments_tab.dart';
import 'package:centrally/screens/teacher/student_profile/widgets/student_profile_header.dart';
import 'package:flutter/material.dart';

/// Student Profile outer screen — matches Figma exactly:
/// - White background, "ملف الطالب" app bar with back button
/// - Header with avatar on the left (RTL), name, group, and 3 status chips
/// - 4 Tabs: بيانات الطالب, الحضور, أكاديميا, المدفوعات (Active tab has blue underline)
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_right, color: ColorManager.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'ملف الطالب',
            style: AppTextStyles.headlineSmall.copyWith(color: ColorManager.textPrimary),
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
              tabs: const [
                Tab(text: 'بيانات الطالب'),
                Tab(text: 'الحضور'),
                Tab(text: 'أكاديميًا'),
                Tab(text: 'المدفوعات'),
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
      ),
    );
  }
}
