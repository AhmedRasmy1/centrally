import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/mock_data/centerly_mock_data.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:flutter/material.dart';

/// Student Payments Tab — matches Figma exactly:
/// - "ملخص المدفوعات" section with 3 stats (المتوقع, تم التحصيل, المتبقي)
/// - "سجل الفواتير" section with list of invoices
class StudentPaymentsTab extends StatelessWidget {
  const StudentPaymentsTab({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final invoices = CenterlyMockData.invoices
        .where((inv) => inv.studentId == student.id)
        .toList();

    final totalExpected =
        invoices.fold<double>(0, (sum, inv) => sum + inv.amount);
    final totalPaid =
        invoices.fold<double>(0, (sum, inv) => sum + inv.paidAmount);
    final totalDue = totalExpected - totalPaid;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
      children: [
        _SectionCard(
          icon: Icons.monetization_on_outlined,
          title: 'ملخص المدفوعات',
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'المتبقي',
                    value: totalDue,
                    valueColor: ColorManager.error,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: _StatBox(
                    label: 'تم التحصيل',
                    value: totalPaid,
                    valueColor: ColorManager.success,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: _StatBox(
                    label: 'المتوقع',
                    value: totalExpected,
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
          title: 'سجل الفواتير',
          child: invoices.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
                  child: Text(
                    'لا توجد فواتير',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    const _TableHeader(),
                    const Divider(height: 1, color: ColorManager.divider),
                    for (final invoice in invoices) ...[
                      _InvoiceRow(invoice: invoice),
                      if (invoice != invoices.last)
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
  final double value;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(0),
                style: AppTextStyles.titleMedium.copyWith(color: valueColor),
              ),
              const SizedBox(width: AppSize.s4),
              Text(
                'جنيه',
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: ColorManager.textSecondary,
                ),
              ),
            ],
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
              'تاريخ الاستحقاق',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'المبلغ',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'الفاتورة',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == InvoiceStatus.paid;
    final color = isPaid ? ColorManager.success : ColorManager.error;
    final label = isPaid ? 'مدفوع' : 'مستحق';
    final icon = isPaid ? Icons.check_circle_outline : Icons.cancel_outlined;

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
                  horizontal: AppPadding.p8,
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
              '${invoice.dueDate.day} مايو',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${invoice.amount.toStringAsFixed(0)} جنيه',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              invoice.invoiceNumber,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
