import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:flutter/material.dart';

class SectionScaffold extends StatelessWidget {
  const SectionScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
    this.actionLabel,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineLarge),
                    const SizedBox(height: AppSize.s6),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: AppSize.s12),
                FilledButton.tonal(onPressed: () {}, child: Text(actionLabel!)),
              ],
            ],
          ),
          const SizedBox(height: AppSize.s24),
          ...children.expand(
            (child) => [child, const SizedBox(height: AppSize.s12)],
          ),
        ],
      ),
    );
  }
}

class SectionListTileCard extends StatelessWidget {
  const SectionListTileCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: ColorManager.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: ColorManager.primary),
        title: Text(title, style: AppTextStyles.titleMedium),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: Text(
          trailing,
          style: AppTextStyles.labelSmall.copyWith(color: ColorManager.primary),
        ),
      ),
    );
  }
}
