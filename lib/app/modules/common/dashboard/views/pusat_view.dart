import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';

class PusatDashboardView extends StatelessWidget {
  final DashboardController controller;

  const PusatDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector (tampilan filter)
            _buildPeriodSelector(),
            const SizedBox(height: 24),

            // Total Income untuk semua cabang
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Income', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('Total', style: Theme.of(context).textTheme.bodySmall),
                    Row(
                      children: [
                        Text('Rp 50.000.000',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0E5937),
                                )),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_downward, size: 12, color: Colors.red.shade800),
                              Text('9.75%', style: TextStyle(fontSize: 12, color: Colors.red.shade800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Net Profit
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Profit', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('Total Income - Expenses', style: Theme.of(context).textTheme.bodySmall),
                    Text('Rp 3.000.000',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0E5937),
                            )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cards untuk cabang-cabang
            Row(
              children: [
                _buildBranchCard(
                  context,
                  branchName: 'Kedai Dandang Gula MT. Haryono',
                  income: 'Rp 10.000.000',
                  cogs: 'Rp 45.000.000',
                  labaKotor: 'Rp 5.000.000',
                  percentage: '-9.75%',
                  isNegative: true,
                ),
                const SizedBox(width: 16),
                _buildBranchCard(
                  context,
                  branchName: 'Ngelaras Rasa MT. Haryono',
                  income: 'Rp 10.000.000',
                  cogs: 'Rp 45.000.000',
                  labaKotor: 'Rp 5.000.000',
                  percentage: '-9.75%',
                  isNegative: true,
                ),
                const SizedBox(width: 16),
                _buildBranchCard(
                  context,
                  branchName: 'Ngelaras Rasa Thamrin',
                  income: 'Rp 10.000.000',
                  cogs: 'Rp 45.000.000',
                  labaKotor: 'Rp 5.000.000',
                  percentage: '-9.75%',
                  isNegative: true,
                ),
                const SizedBox(width: 16),
                _buildBranchCard(
                  context,
                  branchName: 'Ngelaras Rasa',
                  income: 'Rp 10.000.000',
                  cogs: 'Rp 45.000.000',
                  labaKotor: 'Rp 5.000.000',
                  percentage: '-9.75%',
                  isNegative: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grafik Total Income
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Income', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: _buildIncomeChart(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Row dengan branch selector dan grafik Revenue vs Expense
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branch selector
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cabang', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 16),
                          _buildBranchSelectItem(
                            context,
                            name: 'Kedai Dandang Gula MT. Haryono',
                            isSelected: true,
                          ),
                          const SizedBox(height: 8),
                          _buildBranchSelectItem(
                            context,
                            name: 'Kedai Dandang Gula MT. Haryono',
                            isSelected: false,
                          ),
                          const SizedBox(height: 8),
                          _buildBranchSelectItem(
                            context,
                            name: 'Kedai Dandang Gula MT. Haryono',
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Revenue vs Expense chart
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Revenue Vs Expense', style: Theme.of(context).textTheme.titleMedium),
                              Text('Kedai Dandang Gula MT Haryono', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildRevenueExpenseChart(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(context, 'Revenue', const Color(0xFF0E5937)),
                              const SizedBox(width: 24),
                              _buildLegendItem(context, 'Expense', Colors.amber),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row with multiple sales performance charts
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sales Performance', style: Theme.of(context).textTheme.titleMedium),
                          Text('Kedai Dandang Gula MT. Haryono', style: Theme.of(context).textTheme.bodySmall),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sales Performance', style: Theme.of(context).textTheme.titleMedium),
                          Text('Ngelaras Rasa MT. Haryono', style: Theme.of(context).textTheme.bodySmall),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sales Performance', style: Theme.of(context).textTheme.titleMedium),
                          Text('Ngelaras Rasa Thamrin', style: Theme.of(context).textTheme.bodySmall),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Text('Periode Data'),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0E5937),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('Real-time', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          const Text('Hari ini - Pk 00:00 (GMT+07)'),
          const Spacer(),
          const Icon(Icons.calendar_today, size: 18),
        ],
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context, {
    required String branchName,
    required String income,
    required String cogs,
    required String labaKotor,
    required String percentage,
    required bool isNegative,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branch icon and name
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E5937),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.store, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      branchName,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Income
              Row(
                children: [
                  Text('Total Income', style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: isNegative ? Colors.red.shade100 : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isNegative ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 12,
                          color: isNegative ? Colors.red.shade800 : Colors.green.shade800,
                        ),
                        Text(
                          percentage,
                          style: TextStyle(
                            fontSize: 12,
                            color: isNegative ? Colors.red.shade800 : Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(income, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // COGS and Laba Kotor
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('COGS', style: Theme.of(context).textTheme.bodySmall),
                        Text(cogs, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Laba Kotor', style: Theme.of(context).textTheme.bodySmall),
                        Text(labaKotor, style: Theme.of(context).textTheme.bodyMedium),
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

  Widget _buildBranchSelectItem(BuildContext context, {required String name, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0E5937).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? const Color(0xFF0E5937) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0E5937),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.store, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSelected)
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0E5937),
              ),
              margin: const EdgeInsets.only(left: 8),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  // Placeholder widgets untuk chart
  Widget _buildIncomeChart() {
    return Container(color: Colors.grey.shade100);
  }

  Widget _buildRevenueExpenseChart() {
    return Container(color: Colors.grey.shade100);
  }

  Widget _buildSalesPerformanceChart() {
    return Container(color: Colors.grey.shade100);
  }
}
