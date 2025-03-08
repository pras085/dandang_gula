import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/revenue_expense_data.dart';

class RevenueExpenseChart extends StatelessWidget {
  final List<RevenueExpenseData> data;
  final double height;
  final bool showLabels;
  final bool showLegend;

  const RevenueExpenseChart({
    Key? key,
    required this.data,
    this.height = 300,
    this.showLabels = true,
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    // Find max value for scaling
    final maxRevenue = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxExpense = data.map((e) => e.expense).reduce((a, b) => a > b ? a : b);
    final maxValue = maxRevenue > maxExpense ? maxRevenue : maxExpense;
    
    final chartHeight = height - (showLabels ? 30 : 0) - (showLegend ? 40 : 0);

    return Container(
      height: height,
      width: double.infinity,
      child: Column(
        children: [
          if (showLegend)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(AppColors.primary, 'Revenue'),
                  const SizedBox(width: 24),
                  _buildLegendItem(Colors.amber, 'Expense'),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-axis labels
                  if (showLabels)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(maxValue / 1000000).toStringAsFixed(1)}M',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                        Text(
                          '${(maxValue / 2000000).toStringAsFixed(1)}M',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  const SizedBox(width: 8),
                  // Chart
                  Expanded(
                    child: Container(
                      height: chartHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: data.map((item) {
                          final revenueHeight = chartHeight * (item.revenue / maxValue);
                          final expenseHeight = chartHeight * (item.expense / maxValue);
                          
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Grouped bars
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Revenue bar
                                  Container(
                                    width: 20,
                                    height: revenueHeight,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // Expense bar
                                  Container(
                                    width: 20,
                                    height: expenseHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // X-axis label
                              if (showLabels)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${item.date.day}/${item.date.month}',
                                    style: TextStyle(
                                      fontSize: 10, 
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}