import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/payment_method_model.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class PaymentMethodTable extends StatelessWidget {
  final String title;
  final List<PaymentMethod> paymentMethods;
  final VoidCallback onViewAll;

  const PaymentMethodTable({
    Key? key,
    required this.title,
    required this.paymentMethods,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      action: TextButton(
        onPressed: onViewAll,
        child: Row(
          children: [
            AppText(
              'Lainya',
              style: TextStyle(color: AppColors.primary),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      child: Column(
        children: paymentMethods.map((method) {
          return Column(
            children: [
              _buildPaymentMethodRow(method),
              if (method != paymentMethods.last)
                const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethodRow(PaymentMethod method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(
              method.icon,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: AppText(
              method.name,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          AppText(
            'Rp${method.amount.toStringAsFixed(0)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
