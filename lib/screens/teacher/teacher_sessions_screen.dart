import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/teacher_session_details_screen.dart';
import 'package:centrally/screens/teacher/teacher_shared.dart';
import 'package:flutter/material.dart';

/// Sessions screen — 3 views: Day / Week / Month
/// Matches Figma exactly for all three views.
class TeacherSessionsScreen extends StatefulWidget {
  const TeacherSessionsScreen({super.key});

  @override
  State<TeacherSessionsScreen> createState() => _TeacherSessionsScreenState();
}

class _TeacherSessionsScreenState extends State<TeacherSessionsScreen> {
  _View _view = _View.day;
  DateTime _selectedDate = DateTime(2026, 4, 14);

  List<Session> get _selectedDaySessions =>
      CenterlyMockData.sessions
          .where((s) => _sameDay(s.date, _selectedDate))
          .toList();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorManager.background,
          title: Text('الحصص', style: AppTextStyles.headlineSmall),
          actions: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.only(end: AppPadding.p16),
              child: Icon(
                Icons.calendar_today_outlined,
                color: ColorManager.grey500,
                size: AppSize.s20,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _ViewSelector(
              current: _view,
              onChanged: (v) => setState(() => _view = v),
            ),
            Expanded(
              child: switch (_view) {
                _View.day => _DayView(
                    selectedDate: _selectedDate,
                    sessions: _selectedDaySessions,
                    onSessionTap: _openDetails,
                  ),
                _View.week => _WeekView(
                    selectedDate: _selectedDate,
                    sessions: _selectedDaySessions,
                    onDateChanged: (d) =>
                        setState(() => _selectedDate = d),
                    onSessionTap: _openDetails,
                  ),
                _View.month => _MonthView(
                    selectedDate: _selectedDate,
                    sessions: _selectedDaySessions,
                    onDateChanged: (d) =>
                        setState(() => _selectedDate = d),
                    onSessionTap: _openDetails,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(Session session) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TeacherSessionDetailsScreen(session: session),
      ),
    );
  }
}

enum _View { day, week, month }

// ── Segmented view selector ────────────────────────────────────────────────────

class _ViewSelector extends StatelessWidget {
  const _ViewSelector({required this.current, required this.onChanged});

  final _View current;
  final ValueChanged<_View> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p8,
      ),
      child: SegmentedButton<_View>(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: ColorManager.primary,
          selectedForegroundColor: ColorManager.white,
          foregroundColor: ColorManager.textSecondary,
        ),
        segments: const [
          ButtonSegment(value: _View.month, label: Text('الشهر')),
          ButtonSegment(value: _View.week, label: Text('الأسبوع')),
          ButtonSegment(value: _View.day, label: Text('اليوم')),
        ],
        selected: {current},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

// ── Day View ──────────────────────────────────────────────────────────────────

class _DayView extends StatelessWidget {
  const _DayView({
    required this.selectedDate,
    required this.sessions,
    required this.onSessionTap,
  });

  final DateTime selectedDate;
  final List<Session> sessions;
  final ValueChanged<Session> onSessionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      children: [
        const SizedBox(height: AppSize.s8),
        _SummaryStrip(
          expected: 50,
          present: 35,
          count: 5,
          countLabel: 'الحصص اليوم',
        ),
        const SizedBox(height: AppSize.s20),
        Row(
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: AppSize.s18,
              color: ColorManager.primary,
            ),
            const SizedBox(width: AppSize.s6),
            Text('حصص اليوم', style: AppTextStyles.titleMedium),
          ],
        ),
        const SizedBox(height: AppSize.s12),
        if (sessions.isEmpty)
          const TeacherEmptyState(
            title: 'لا توجد حصص اليوم',
            subtitle: 'لم يتم جدولة أي حصص في هذا اليوم.',
            icon: Icons.calendar_month_outlined,
          )
        else
          for (final session in sessions) ...[
            TeacherSessionCard(
              session: session,
              highlight: session.status == SessionStatus.ongoing,
              onTap: () => onSessionTap(session),
            ),
            const SizedBox(height: AppSize.s10),
          ],
      ],
    );
  }
}

// ── Week View ─────────────────────────────────────────────────────────────────

class _WeekView extends StatelessWidget {
  const _WeekView({
    required this.selectedDate,
    required this.sessions,
    required this.onDateChanged,
    required this.onSessionTap,
  });

  final DateTime selectedDate;
  final List<Session> sessions;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<Session> onSessionTap;

  static const _days = [
    ('السبت', 11),
    ('الأحد', 12),
    ('الإثنين', 13),
    ('الثلاثاء', 14),
    ('الأربعاء', 15),
    ('الخميس', 16),
    ('الجمعة', 17),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      children: [
        const SizedBox(height: AppSize.s8),
        // Week navigation header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.chevron_left,
              color: ColorManager.grey500,
            ),
            Text('10-17 أبريل 2026', style: AppTextStyles.titleSmall),
            const Icon(
              Icons.chevron_right,
              color: ColorManager.grey500,
            ),
          ],
        ),
        const SizedBox(height: AppSize.s10),
        // Day pills
        Row(
          children: [
            for (final day in _days)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s2,
                  ),
                  child: _DayPill(
                    dayName: day.$1,
                    dayNumber: day.$2,
                    selected: selectedDate.day == day.$2,
                    onTap: () => onDateChanged(DateTime(2026, 4, day.$2)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSize.s16),
        _SummaryStrip(
          expected: 210,
          present: 168,
          count: 22,
          countLabel: 'إجمالي الحصص',
        ),
        const SizedBox(height: AppSize.s20),
        Text(
          _dateLabel(selectedDate),
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppSize.s12),
        if (sessions.isEmpty)
          const TeacherEmptyState(
            title: 'لا توجد حصص',
            subtitle: 'لا توجد حصص في هذا اليوم.',
            icon: Icons.calendar_month_outlined,
          )
        else
          for (final session in sessions) ...[
            TeacherSessionCard(
              session: session,
              highlight: session.status == SessionStatus.ongoing,
              onTap: () => onSessionTap(session),
            ),
            const SizedBox(height: AppSize.s10),
          ],
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.dayName,
    required this.dayNumber,
    required this.selected,
    required this.onTap,
  });

  final String dayName;
  final int dayNumber;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
        decoration: BoxDecoration(
          color: selected ? ColorManager.primary : ColorManager.grey200,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        ),
        child: Column(
          children: [
            Text(
              dayName,
              style: AppTextStyles.labelSmall.copyWith(
                color: selected
                    ? ColorManager.white
                    : ColorManager.textSecondary,
                fontSize: 9,
              ),
            ),
            Text(
              dayNumber.toString(),
              style: AppTextStyles.labelSmall.copyWith(
                color: selected ? ColorManager.white : ColorManager.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Month View ────────────────────────────────────────────────────────────────

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.selectedDate,
    required this.sessions,
    required this.onDateChanged,
    required this.onSessionTap,
  });

  final DateTime selectedDate;
  final List<Session> sessions;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<Session> onSessionTap;

  // Days in the April 2026 calendar grid (starting from Sunday column)
  static const _calendarDays = [
    29, 30, 31, 1, 2, 3, 4,
    5, 6, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24, 25,
    26, 27, 28, 29, 30, 1, 2,
  ];
  // Indices 3..32 are April days (index 3 = April 1)
  static const _aprilStart = 3;
  static const _aprilEnd = 32;

  // Sessions that have dots (April 2026)
  static const _sessionDays = [14, 15, 17];
  static const _cancelledDays = [17];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      children: [
        const SizedBox(height: AppSize.s8),
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left, color: ColorManager.grey500),
            Text('أبريل 2026', style: AppTextStyles.titleSmall),
            const Icon(Icons.chevron_right, color: ColorManager.grey500),
          ],
        ),
        const SizedBox(height: AppSize.s10),
        // Day-of-week header
        Row(
          children: [
            for (final d in const [
              'الأحد',
              'الإثنين',
              'الثلاثاء',
              'الأربعاء',
              'الخميس',
              'الجمعة',
              'السبت',
            ])
              Expanded(
                child: Text(
                  d,
                  style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSize.s6),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _calendarDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 38,
          ),
          itemBuilder: (context, index) {
            final day = _calendarDays[index];
            final inApril =
                index >= _aprilStart && index <= _aprilEnd;
            final isSelected =
                inApril && selectedDate.day == day;
            final hasSession = inApril && _sessionDays.contains(day);
            final isCancelled = inApril && _cancelledDays.contains(day);

            return GestureDetector(
              onTap: inApril
                  ? () => onDateChanged(DateTime(2026, 4, day))
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: AppSize.s28,
                    height: AppSize.s28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManager.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: !inApril
                            ? ColorManager.textDisabled
                            : isSelected
                                ? ColorManager.white
                                : ColorManager.textPrimary,
                      ),
                    ),
                  ),
                  if (hasSession)
                    Container(
                      width: AppSize.s5,
                      height: AppSize.s5,
                      margin: const EdgeInsets.only(top: AppSize.s2),
                      decoration: BoxDecoration(
                        color: isCancelled
                            ? ColorManager.error
                            : ColorManager.success,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: AppSize.s8),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppSize.s6),
        // Legend
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: ColorManager.grey500, label: 'حصص انتهت'),
            SizedBox(width: AppSize.s12),
            _LegendDot(color: ColorManager.success, label: 'حصص متاحة'),
            SizedBox(width: AppSize.s12),
            _LegendDot(color: ColorManager.error, label: 'حصص ملغية'),
          ],
        ),
        const SizedBox(height: AppSize.s16),
        // Month summary strip
        Text('ملخص شهر أبريل', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSize.s10),
        _SummaryStrip(
          expected: 870,
          present: 700,
          count: 88,
          countLabel: 'إجمالي الحصص',
          cancelled: 6,
        ),
        const SizedBox(height: AppSize.s20),
        Text(
          _dateLabel(selectedDate),
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppSize.s12),
        if (sessions.isEmpty)
          const TeacherEmptyState(
            title: 'لا توجد حصص',
            subtitle: 'لا توجد حصص في هذا اليوم.',
            icon: Icons.calendar_month_outlined,
          )
        else
          for (final session in sessions) ...[
            TeacherSessionCard(
              session: session,
              highlight: session.status == SessionStatus.ongoing,
              onTap: () => onSessionTap(session),
            ),
            const SizedBox(height: AppSize.s10),
          ],
        const SizedBox(height: AppSize.s24),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.s6,
          height: AppSize.s6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSize.s4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
      ],
    );
  }
}

// ── Summary Strip (3-stat card) ───────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.expected,
    required this.present,
    required this.count,
    required this.countLabel,
    this.cancelled,
  });

  final int expected;
  final int present;
  final int count;
  final String countLabel;
  final int? cancelled;

  @override
  Widget build(BuildContext context) {
    return TeacherCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p12,
        horizontal: AppPadding.p8,
      ),
      child: cancelled != null
          ? Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.menu_book_outlined,
                    value: count.toString(),
                    label: countLabel,
                    color: ColorManager.primary,
                  ),
                ),
                const _Divider(),
                Expanded(
                  child: _StatItem(
                    icon: Icons.check_circle_outline,
                    value: present.toString(),
                    label: 'إجمالي الحضور',
                    color: ColorManager.success,
                  ),
                ),
                const _Divider(),
                Expanded(
                  child: _StatItem(
                    icon: Icons.people_outline,
                    value: expected.toString(),
                    label: 'الطلاب المتوقعين',
                    color: ColorManager.textPrimary,
                  ),
                ),
                const _Divider(),
                Expanded(
                  child: _StatItem(
                    icon: Icons.cancel_outlined,
                    value: cancelled.toString(),
                    label: 'الحصص الملغاة',
                    color: ColorManager.error,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.people_outline,
                    value: expected.toString(),
                    label: 'الطلاب المتوقعين',
                    color: ColorManager.textPrimary,
                  ),
                ),
                const _Divider(),
                Expanded(
                  child: _StatItem(
                    icon: Icons.check_circle_outline,
                    value: present.toString(),
                    label: 'الطلاب الحاضرين',
                    color: ColorManager.success,
                  ),
                ),
                const _Divider(),
                Expanded(
                  child: _StatItem(
                    icon: Icons.menu_book_outlined,
                    value: count.toString(),
                    label: countLabel,
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSize.s14),
            const SizedBox(width: AppSize.s4),
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSize.s36,
      child: VerticalDivider(width: AppSize.s1),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

const _arabicDayNames = [
  '',
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

const _arabicMonths = [
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

String _dateLabel(DateTime d) =>
    '${_arabicDayNames[d.weekday]} ${d.day} ${_arabicMonths[d.month]} ${d.year}';
