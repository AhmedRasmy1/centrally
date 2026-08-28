import 'package:centrally/core/constants/strings_manager.dart';
import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/core/utils/cached_data_shared_preferences.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/teacher/teacher_groups_screen.dart';
import 'package:centrally/screens/teacher/teacher_home_screen.dart';
import 'package:centrally/screens/teacher/teacher_sessions_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The main shell for Teacher role — shows the 4-tab bottom navigation
/// matching the Figma design: الرئيسية / الحصص / المجموعات / المالية
class MainShellView extends StatefulWidget {
  const MainShellView({required this.role, super.key});

  final UserRole role;

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _index = 3; // default to Home (rightmost tab in RTL)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _buildPages(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: ColorManager.surface,
        indicatorColor: ColorManager.primaryBright,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          _navItem(
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
            label: StringsManager.navFinance.tr(),
          ),
          _navItem(
            icon: Icons.groups_2_outlined,
            selectedIcon: Icons.groups_2,
            label: StringsManager.navGroups.tr(),
          ),
          _navItem(
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month,
            label: StringsManager.navSessions.tr(),
          ),
          _navItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: StringsManager.navHome.tr(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPages() {
    if (widget.role == UserRole.teacher) {
      return [
        _FinancePlaceholder(onLogout: _logout),
        const TeacherGroupsScreen(),
        const TeacherSessionsScreen(),
        const TeacherHomeScreen(),
      ];
    }
    // Secretary placeholder — Phase 3
    return [
      _SecretaryPlaceholder(
        label: StringsManager.navFinance.tr(),
        onLogout: _logout,
      ),
      _SecretaryPlaceholder(
        label: StringsManager.navGroups.tr(),
        onLogout: _logout,
      ),
      _SecretaryPlaceholder(
        label: StringsManager.navSessions.tr(),
        onLogout: _logout,
      ),
      _SecretaryPlaceholder(
        label: StringsManager.navHome.tr(),
        onLogout: _logout,
      ),
    ];
  }

  Future<void> _logout() async {
    await CacheService.deleteItem(key: CacheConstants.userToken);
    await CacheService.deleteItem(key: CacheConstants.role);
    if (mounted) context.goNamed(RoutesManager.loginName);
  }
}

NavigationDestination _navItem({
  required IconData icon,
  required IconData selectedIcon,
  required String label,
}) =>
    NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon, color: ColorManager.primary),
      label: label,
    );

// ── Finance placeholder (Phase 3 scope) ─────────────────────────────────────

class _FinancePlaceholder extends StatelessWidget {
  const _FinancePlaceholder({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(StringsManager.navFinance.tr()),
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_outlined),
            tooltip: StringsManager.actionLogout.tr(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: AppSize.s64,
                color: ColorManager.grey300,
              ),
              const SizedBox(height: AppSize.s16),
              Text(
                StringsManager.financeComingSoon.tr(),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: ColorManager.textSecondary,
                ),
              ),
              const SizedBox(height: AppSize.s8),
              Text(
                StringsManager.financeComingSoonSubtitle.tr(),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Secretary placeholder (Phase 3 scope) ───────────────────────────────────

class _SecretaryPlaceholder extends StatelessWidget {
  const _SecretaryPlaceholder({
    required this.label,
    required this.onLogout,
  });

  final String label;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(label),
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_outlined),
            tooltip: StringsManager.actionLogout.tr(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Secretary — $label (Phase 3)',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
