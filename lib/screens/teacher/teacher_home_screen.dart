import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/teacher_session_details_screen.dart';
import 'package:centrally/screens/teacher/teacher_my_secretary_screen.dart';
import 'package:centrally/screens/teacher/teacher_shared.dart';
import 'package:flutter/material.dart';

/// Teacher Home Screen — matches Figma:
/// - Blue header with bell, teacher name, date, avatar
/// - Stats: 7 حصص اليوم / 9 ساعات عمل اليوم
/// - Today's sessions list with status chip (تمت / الآن / قادم)
/// - Finance summary card with progress bar
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = CenterlyMockData.sessions
        .where((s) => s.date.day == 14 && s.date.month == 4)
        .toList();

    final totalExpected = CenterlyMockData.invoices
        .fold<double>(0, (sum, inv) => sum + inv.amount);
    final totalCollected = CenterlyMockData.invoices
        .fold<double>(0, (sum, inv) => sum + inv.paidAmount);
    final totalDue = totalExpected - totalCollected;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: CustomScrollView(
          slivers: [
            _HomeAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(AppPadding.p16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _StatsRow(),
                  const SizedBox(height: AppSize.s24),
                  TeacherSectionTitle(
                    title: 'حصص اليوم',
                    actionLabel: 'عرض الكل',
                    onAction: () {},
                  ),
                  const SizedBox(height: AppSize.s12),
                  for (final session in sessions) ...[
                    _HomeSessionCard(
                      session: session,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TeacherSessionDetailsScreen(
                            session: session,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.s10),
                  ],
                  const SizedBox(height: AppSize.s24),
                  TeacherSectionTitle(
                    title: 'الأمور المالية هذا الشهر',
                    actionLabel: 'عرض التفاصيل',
                    onAction: () {},
                  ),
                  const SizedBox(height: AppSize.s12),
                  _FinanceCard(
                    expected: totalExpected,
                    collected: totalCollected,
                    due: totalDue,
                  ),
                  const SizedBox(height: AppSize.s24),
                  TeacherSectionTitle(
                    title: 'فريق العمل',
                    actionLabel: 'إدارة السكرتارية',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TeacherMySecretaryScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  _TeamCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TeacherMySecretaryScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Blue App Bar ─────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: AppSize.s100,
      pinned: true,
      backgroundColor: ColorManager.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            48.0,
            AppPadding.p16,
            AppPadding.p12,
          ),
          child: Row(
            children: [
              Container(
                width: AppSize.s40,
                height: AppSize.s40,
                decoration: BoxDecoration(
                  color: ColorManager.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: ColorManager.white,
                  size: AppSize.s24,
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'صباح الخير, علي',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: ColorManager.white,
                    ),
                  ),
                  Text(
                    teacherTodayLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: ColorManager.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSize.s12),
              const StudentAvatar(radius: AppSize.s20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TeacherStatCard(
            title: 'حصص اليوم',
            value: '7',
            color: ColorManager.textPrimary,
            icon: Icons.menu_book_outlined,
          ),
        ),
        const SizedBox(width: AppSize.s12),
        const Expanded(
          child: TeacherStatCard(
            title: 'ساعات عمل اليوم',
            value: '9',
            color: ColorManager.textPrimary,
            icon: Icons.schedule_outlined,
          ),
        ),
      ],
    );
  }
}

// ── Home Session Card with status chip ───────────────────────────────────────

class _HomeSessionCard extends StatelessWidget {
  const _HomeSessionCard({
    required this.session,
    required this.onTap,
  });

  final Session session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final group = CenterlyMockData.groupById(session.groupId);
    final (statusLabel, statusColor) = _sessionStatusChip(session.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: TeacherCard(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: Row(
          children: [
            // Status chip on right (RTL)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p8,
                vertical: AppPadding.p4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
              child: Text(
                statusLabel,
                style: AppTextStyles.labelSmall.copyWith(color: statusColor),
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${group.name} - ${group.subjectName}',
                        style: AppTextStyles.titleSmall,
                      ),
                      const SizedBox(width: AppSize.s6),
                      Text(
                        '${session.expectedStudentsCount ~/ 10}ث',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    '11:00 ص - 12:00 م',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSize.s8),
            const Icon(
              Icons.chevron_left,
              color: ColorManager.grey500,
              size: AppSize.s20,
            ),
          ],
        ),
      ),
    );
  }
}

(String, Color) _sessionStatusChip(SessionStatus status) => switch (status) {
  SessionStatus.completed => ('تمت', ColorManager.grey500),
  SessionStatus.ongoing => ('الآن', ColorManager.primary),
  SessionStatus.upcoming => ('قادم', ColorManager.success),
  SessionStatus.cancelled => ('ملغية', ColorManager.error),
};

// ── Finance Card ─────────────────────────────────────────────────────────────

class _FinanceCard extends StatelessWidget {
  const _FinanceCard({
    required this.expected,
    required this.collected,
    required this.due,
  });

  final double expected;
  final double collected;
  final double due;

  @override
  Widget build(BuildContext context) {
    final rate = expected == 0 ? 0.0 : collected / expected;

    return TeacherCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _MoneyTile(
                  title: 'المتوقع',
                  value: expected,
                  color: ColorManager.textPrimary,
                ),
              ),
              Expanded(
                child: _MoneyTile(
                  title: 'المحصل',
                  value: collected,
                  color: ColorManager.success,
                ),
              ),
              Expanded(
                child: _MoneyTile(
                  title: 'المتبقي',
                  value: due,
                  color: ColorManager.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s12),
          Text(
            '${(rate * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: ColorManager.warning,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: AppSize.s4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.circular),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: AppSize.s10,
              backgroundColor: ColorManager.warningLight,
              color: ColorManager.warning,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          Row(
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('عرض القائمة'),
              ),
              const Spacer(),
              Text(
                '8',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: ColorManager.textPrimary,
                ),
              ),
              const SizedBox(width: AppSize.s6),
              Text(
                'طلاب لم يسددوا\nهذا الشهر',
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(width: AppSize.s8),
              Container(
                width: AppSize.s40,
                height: AppSize.s40,
                decoration: BoxDecoration(
                  color: ColorManager.errorLight,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: ColorManager.error,
                  size: AppSize.s24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoneyTile extends StatelessWidget {
  const _MoneyTile({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.labelSmall,
        ),
        const SizedBox(height: AppSize.s4),
        Text(
          _formatMoney(value),
          style: AppTextStyles.titleMedium.copyWith(color: color),
        ),
      ],
    );
  }
}

String _formatMoney(double value) {
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
  }
  return value.toStringAsFixed(0);
}

// ── Team Card ────────────────────────────────────────────────────────────────

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: TeacherCard(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: Row(
          children: [
            Container(
              width: AppSize.s40,
              height: AppSize.s40,
              decoration: BoxDecoration(
                color: ColorManager.primaryLight.withAlpha(50),
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: const Icon(
                Icons.people_outline,
                color: ColorManager.primary,
                size: AppSize.s20,
              ),
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة السكرتارية',
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    'عرض وإدارة أفراد طاقم العمل',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_left,
              color: ColorManager.grey500,
              size: AppSize.s20,
            ),
          ],
        ),
      ),
    );
  }
}

