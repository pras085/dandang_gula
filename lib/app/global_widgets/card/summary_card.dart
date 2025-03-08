import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? secondaryValue;
  final double? percentChange;
  final IconData? icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.secondaryValue,
    this.percentChange,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) ...[
            AppText(
              subtitle!,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppDimensions.spacing8),
          ],
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spacing8),
              ],
              Expanded(
                child: AppText(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (secondaryValue != null) ...[
            const SizedBox(height: AppDimensions.spacing8),
            AppText(
              secondaryValue!,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (percentChange != null) ...[
            const SizedBox(height: AppDimensions.spacing8),
            Row(
              children: [
                AppText(
                  'vs hari sebelumnya',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(width: AppDimensions.spacing4),
                Icon(
                  percentChange! >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: percentChange! >= 0 ? AppColors.success : AppColors.error,
                  size: 12,
                ),
                AppText(
                  '${percentChange!.abs().toStringAsFixed(2)}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: percentChange! >= 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
