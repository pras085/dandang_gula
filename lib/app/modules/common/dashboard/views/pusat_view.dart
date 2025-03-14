import 'package:dandang_gula/app/data/models/branch_model.dart';
import 'package:dandang_gula/app/global_widgets/charts/revenue_vs_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/buttons/icon_button.dart';
import '../../../../global_widgets/charts/total_income_chart.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/dashboard_controller.dart';

class PusatDashboardView extends StatelessWidget {
  final DashboardController controller;

  const PusatDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector (tampilan filter)
          _buildPeriodSelector(),
          const SizedBox(height: AppDimensions.spacing10),

          // Total Income untuk semua cabang
          SizedBox(
            height: 258,
            child: Row(
              children: [
                Card(
                  color: AppColors.white,
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Obx(() {
                      final dashboardSummary = controller.dashboardRepository.dashboardSummary.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Total Income',
                            style: AppTextStyles.cardLabel.copyWith(fontSize: 16),
                          ),
                          AppText(
                            'Semua Cabang',
                            style: AppTextStyles.cardLabel.copyWith(
                              fontSize: 10,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppText(
                            'Total',
                            style: AppTextStyles.cardLabel.copyWith(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          AppText(
                            CurrencyFormatter.formatRupiah(dashboardSummary.totalIncome),
                            style: AppTextStyles.cardLabel.copyWith(
                              fontSize: 18,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          Row(
                            children: [
                              AppText(
                                'vs hari sebelumnya',
                                style: AppTextStyles.cardLabel.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkGrey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SvgPicture.asset(
                                !dashboardSummary.percentChange.isNegative ? AppIcons.caretUp : AppIcons.caretUp,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  !dashboardSummary.percentChange.isNegative ? AppColors.redCaretDown : AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 2),
                              AppText(
                                '${dashboardSummary.percentChange.abs().toStringAsFixed(2)}%',
                                style: AppTextStyles.cardLabel.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: !dashboardSummary.percentChange.isNegative ? AppColors.redCaretDown : AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 1,
                            width: 174,
                            color: AppColors.divider,
                          ),

                          // Net Profit
                          AppText(
                            'Net Profit',
                            style: AppTextStyles.cardLabel.copyWith(fontSize: 16),
                          ),
                          AppText(
                            'Total Income - Expenses',
                            style: AppTextStyles.cardLabel.copyWith(
                              fontSize: 10,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),

                          AppText(
                            CurrencyFormatter.formatRupiah(dashboardSummary.netProfit),
                            style: AppTextStyles.cardLabel.copyWith(
                              fontSize: 18,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                // Cards untuk cabang-cabang
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Obx(() {
                      final branches = controller.branchRepository.branches;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            branches.length,
                            (index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBranchCard(
                                    context,
                                    branch: branches[index],
                                  ),
                                  // Add divider between branch cards except for the last one
                                  if (index < branches.length - 1)
                                    Container(
                                      width: 1,
                                      height: 210,
                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                      color: AppColors.divider,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grafik Total Income
          Obx(() {
            return TotalIncomeChart(
              data: controller.dashboardRepository.incomeChartData.value,
            );
          }),
          const SizedBox(height: 24),

          // Row dengan branch selector dan grafik Revenue vs Expense
          Container(
            width: double.infinity,
            height: 319,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branch selector (left side)
                SizedBox(
                  width: 274,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Cabang" label
                      const Text(
                        'Cabang',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.04,
                          color: Color(0xFFA9AEB3),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Branch selector items
                      Obx(() {
                        final branches = controller.branchRepository.branches;
                        final selectedBranchId = controller.selectedBranchId.value;

                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: branches.map((branch) {
                                final isSelected = branch.id == selectedBranchId;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: _buildBranchSelectItem(
                                    context,
                                    branch: branch,
                                    isSelected: isSelected,
                                    onTap: () => controller.selectBranch(branch.id),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

// Revenue vs Expense chart (right side)
                Expanded(
                  child: Obx(() {
                    final selectedBranchId = controller.selectedBranchId.value;
                    final selectedBranch = controller.branchRepository.getBranchById(selectedBranchId);

                    // Trigger update when branch selection changes
                    if (selectedBranchId.isNotEmpty) {
                      // This call ensures the chart data is updated when branch changes
                      controller.dashboardRepository.fetchRevenueExpenseData(selectedBranchId);
                    }

                    return Expanded(
                      child: Obx(() {
                        return RevenueVsExpenseChart(
                          data: controller.dashboardRepository.revenueExpenseData.value,
                          branchName: selectedBranch?.name ?? 'Semua Cabang',
                          height: 243,
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Row with multiple sales performance charts
          Obx(() {
            final branches = controller.branchRepository.branches.take(3).toList();

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
                                SizedBox(
                                  height: 250,
                                  child: _buildSalesPerformanceChart(),
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
          }),
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

  Widget _buildBranchCard(
    BuildContext context, {
    required Branch branch,
  }) {
    final isNegative = branch.percentChange < 0;

    return SizedBox(
      width: 261,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branch icon and name
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      AppIcons.appIcon,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      branch.name,
                      style: AppTextStyles.cardLabel.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Income
              AppText(
                'Total Income',
                style: AppTextStyles.cardLabel.copyWith(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppText(
                CurrencyFormatter.formatRupiah(branch.income),
                style: AppTextStyles.cardLabel.copyWith(
                  fontSize: 18,
                  color: AppColors.darkGreen,
                ),
              ),
              Row(
                children: [
                  AppText(
                    'vs hari sebelumnya',
                    style: AppTextStyles.cardLabel.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SvgPicture.asset(
                    isNegative ? AppIcons.caretUp : AppIcons.caretUp,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      isNegative ? AppColors.redCaretDown : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 2),
                  AppText(
                    '${branch.percentChange.abs().toStringAsFixed(2)}%',
                    style: AppTextStyles.cardLabel.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isNegative ? AppColors.redCaretDown : AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                height: 1,
                color: AppColors.divider,
              ),

              // COGS and Laba Kotor
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'COGS',
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          CurrencyFormatter.formatRupiah(branch.cogs),
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Laba Kotor',
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          CurrencyFormatter.formatRupiah(branch.netProfit),
                          style: AppTextStyles.cardLabel.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Update the branch selection item to match design
  Widget _buildBranchSelectItem(
    BuildContext context, {
    required Branch branch,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isSelected ? const Color(0xFF88DE7B) : const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Selection indicator (circle)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF88DE7B) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFE1E1E1),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: Color(0xFF88DE7B),
                          spreadRadius: 1,
                          blurRadius: 0,
                        )
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 8),

            // Branch icon (placeholder)
            Image.asset(
              AppIcons.appIcon,
              height: 35,
              width: 35,
            ),

            const SizedBox(width: 8),

            // Branch name
            Expanded(
              child: Text(
                branch.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.25, // line-height: 15px
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesPerformanceChart() {
    return Container(color: Colors.grey.shade100);
  }
}
