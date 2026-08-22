import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:flutter/material.dart';

/// Student Info Tab — matches Figma exactly:
/// - معلومات التواصل card (phone, guardian phone) with circle call/whatsapp icons
/// - ملاحظات المدرس card with grey box and "تعديل الملاحظة" button
/// - QR Code card
class StudentInfoTab extends StatelessWidget {
  const StudentInfoTab({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        _SectionCard(
          title: 'معلومات التواصل',
          icon: Icons.phone_in_talk_outlined,
          child: Column(
            children: [
              _ContactRow(
                label: 'هاتف الطالب',
                phone: student.phone,
              ),
              const Divider(height: 1, color: ColorManager.divider),
              _ContactRow(
                label: 'هاتف ولي الأمر',
                phone: student.guardianPhone,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s16),
        _SectionCard(
          title: 'ملاحظات المدرس',
          icon: Icons.assignment_outlined,
          child: Container(
            margin: const EdgeInsets.all(AppPadding.p14),
            padding: const EdgeInsets.all(AppPadding.p14),
            decoration: BoxDecoration(
              color: ColorManager.grey200,
              borderRadius: BorderRadius.circular(AppRadius.r8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.teacherNote ??
                      'أحمد جيد في النحو لكنه يفتقر إلى الممارسة ولديه قصور في البلاغة ويحتاج للتركيز على الأدب',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSize.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'آخر تحديث: 12 مايو',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: ColorManager.textSecondary,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: AppSize.s16),
                      label: const Text('تعديل الملاحظة'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p12,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, AppSize.s32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSize.s16),
        _SectionCard(
          title: 'QR Code',
          icon: Icons.qr_code_scanner_outlined,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'يتم مسح كود الطالب لتأكيد حضوره',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: ColorManager.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSize.s8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p16,
                          vertical: AppPadding.p8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.grey200,
                          borderRadius: BorderRadius.circular(AppRadius.r8),
                        ),
                        child: Text(
                          'معرف الطالب: #${student.qrCodeValue}',
                          style: AppTextStyles.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Container(
                  width: AppSize.s80,
                  height: AppSize.s80,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    border: Border.all(color: ColorManager.divider),
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  child: const Center(
                    child: Icon(Icons.qr_code_2, size: AppSize.s64),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Icon(
                    icon,
                    size: AppSize.s18,
                    color: ColorManager.primary,
                  ),
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

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.label, required this.phone});

  final String label;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p14),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.chat_outlined,
            color: ColorManager.success,
            onTap: () {},
          ),
          const SizedBox(width: AppSize.s12),
          _CircleIconButton(
            icon: Icons.call_outlined,
            color: ColorManager.primary,
            onTap: () {},
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: AppTextStyles.labelSmall),
              Text(phone, style: AppTextStyles.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.circular),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p8),
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.circle,
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Icon(icon, size: AppSize.s18, color: color),
      ),
    );
  }
}
