import 'package:dandang_gula/app/global_widgets/charts/sales_performance_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../data/models/branch_model.dart';
import '../../../../global_widgets/buttons/icon_button.dart';
import '../../../../global_widgets/charts/total_income_chart.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/revenue_expense_chart_card.dart';
import '../widgets/total_income_card.dart';

class PusatDashboardView extends StatelessWidget {
  final DashboardController controller;

  const PusatDashboardView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          _buildPeriodSelector(),
          const SizedBox(height: AppDimensions.spacing10),

          // Total Income Card
          TotalIncomeCard(controller: controller),
          const SizedBox(height: 24),

          // Total Income Chart
          Obx(() {
            return TotalIncomeChart(
              data: controller.dashboardRepository.incomeChartData.value,
            );
          }),
          const SizedBox(height: 24),

          // Revenue vs Expense Chart Card
          RevenueExpenseChartCard(controller: controller),
          const SizedBox(height: 24),

          // Sales Performance Charts
          _buildSalesPerformanceCharts(context),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 412),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                'Periode Data',
                style: AppTextStyles.contentLabel,
              ),
              const SizedBox(width: AppDimensions.spacing20),
              AppText(
                'Real-time',
                style: AppTextStyles.contentLabel.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              AppText(
                'Hari ini - Pk 00:00 (GMT+07)',
                style: AppTextStyles.contentLabel,
              ),
              const SizedBox(width: AppDimensions.spacing4),
              AppIconButton(
                icon: AppIcons.calendarDot,
                onPressed: () {
                  // Handle calendar
                },
                backgroundColor: Colors.transparent,
                iconColor: AppColors.textDisabled,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesPerformanceCharts(BuildContext context) {
    return Obx(() {
      final branches = controller.branchRepository.branches.take(1).toList();

      return Row(
        children: branches.asMap().entries.map((entry) {
          final index = entry.key;
          final branch = entry.value;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sales Performance', style: Theme.of(context).textTheme.titleMedium),
                          Text(branch.name, style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SalesPerformanceChart(
                              data: controller.dashboardRepository.incomeChartData.value,
                              branchName: branch.name,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (index < branches.length - 1) const SizedBox(width: 16),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
