import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../data/models/revenue_expense_data.dart';
import '../layout/app_layout.dart';
import '../text/app_text.dart';

class RevenueVsExpenseChart extends StatelessWidget {
  final List<RevenueExpenseData> data;
  final String branchName;
  final double height;

  const RevenueVsExpenseChart({
    super.key,
    required this.data,
    required this.branchName,
    this.height = 350,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and branch name row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              'Revenue Vs Expense',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            AppText(
              branchName,
              style: AppTextStyles.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chart
        SizedBox(
          height: height, // Adjust for padding and legend
          child: data.isEmpty
              ? Center(
                  child: AppText(
                    'No data available',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                  ),
                )
              : _buildChart(),
        ),

        // Legend
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF136C3A), 'Revenue'),
            const SizedBox(width: 24),
            _buildLegendItem(const Color(0xFFE7B776), 'Expense'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 6),
        AppText(
          label,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chart content
            Expanded(
              child: _buildGridAndBars(constraints),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridAndBars(BoxConstraints constraints) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    // Calculate grid dimensions
    final double barSpacing = constraints.maxWidth / data.length;

    return Stack(
      children: [
        // Grid lines
        _buildGridLines(constraints),

        // Bars
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(data.length, (index) {
            final item = data[index];
            // Find max value for scaling
            final maxValue = data.map((e) => e.revenue > e.expense ? e.revenue : e.expense).reduce((a, b) => a > b ? a : b);

            // Calculate bar heights - reserve proper space for labels
            final double maxHeight = constraints.maxHeight * 0.8; // Use 80% of height for bars, 20% for labels
            final double revenueHeight = (item.revenue / maxValue) * maxHeight;
            final double expenseHeight = (item.expense / maxValue) * maxHeight;

            return SizedBox(
              width: barSpacing,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Revenue bar
                      _buildBar(
                        height: revenueHeight,
                        color: const Color(0xFF136C3A),
                        value: item.revenue,
                        maxHeight: maxHeight,
                      ),
                      const SizedBox(width: 4),
                      // Expense bar
                      _buildBar(
                        height: expenseHeight,
                        color: const Color(0xFFE7B776),
                        value: item.expense,
                        maxHeight: maxHeight,
                      ),
                    ],
                  ),

                  // Date label
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AppText(
                      'Jan ${item.date.day}',
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                        letterSpacing: -0.04,
                        color: Color(0xFFA9AEB3),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBar({
    required double height,
    required Color color,
    required double value,
    required double maxHeight,
  }) {
    // Ensure minimum visible height
    final displayHeight = height < 10 && height > 0 ? 10.0 : height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label for bars
        if (height > 30)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: AppText(
              value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
              style: const TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w400,
                fontSize: 10.5,
                letterSpacing: -0.04,
                color: Colors.white,
              ),
            ),
          ),

        // The bar itself
        Container(
          width: 32,
          height: displayHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,

          // Only show value inside short bars (we already show it above tall bars)
          child: height <= 30 && height >= 20
              ? AppText(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 10.5,
                    letterSpacing: -0.04,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildGridLines(BoxConstraints constraints) {
    return Column(
      children: List.generate(5, (index) {
        // Divide height into 5 equal parts
        final lineY = index * (constraints.maxHeight - 32) / 4;
        return Positioned(
          top: lineY,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: const Color(0xFFEAEEF2), // Light border color from CSS
          ),
        );
      }),
    );
  }
}
