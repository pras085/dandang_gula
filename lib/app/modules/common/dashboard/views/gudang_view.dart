import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils.dart';
import '../../../../global_widgets/card/summary_card.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/table/stock_alert_table.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../global_widgets/charts/stock_flow_chart.dart';
import '../../../../global_widgets/charts/stock_usage_chart.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../routes/app_routes.dart';

class GudangDashboardView extends StatelessWidget {
  final DashboardController controller;

  const GudangDashboardView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget untuk periode data (tampilan filter)
          _buildPeriodSelector(),
          const SizedBox(height: 24),

          // Row dengan card informasi total bahan
          const SummaryCard(
            title: 'Total Bahan',
            value: '120',
            secondaryValue: 'Items',
            icon: Icons.category,
          ),
          const SizedBox(height: 16),

          // Informasi Stok Masuk
          const AppCard(
            title: 'Stok Masuk',
            action: AppText(
              'Hari ini',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('Jumlah items'),
                AppText(
                  '15',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                AppText('Total'),
                AppText(
                  'Rp 1.000.000',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stok Terbuang
          AppCard(
            title: 'Stok Terbuang',
            action: const AppText(
              'Hari ini',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bars untuk alasan pembuangan stok
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText('Expired'),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    const AppText('Kesalahan Produksi'),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.4,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    const AppText('Lain-lain'),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.2,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grafik Statistik Arus Stok
          AppCard(
            title: 'Statistik arus stok',
            action: const AppText('Hari ini - Pk 00:00 (GMT+07)'),
            child: SizedBox(
              height: 250,
              child: StockFlowChart(
                data: controller.stockFlowData,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stock Alert
          StockAlertTable(
            title: 'Stock alert',
            stockAlerts: controller.stockAlerts,
            onViewAll: () {
              // Action untuk melihat semua stock alert
            },
          ),
          const SizedBox(height: 24),

          // Heat Map penggunaan stock
          AppCard(
            title: 'Metric Stock usage',
            child: SizedBox(
              height: 250,
              child: _buildStockUsageHeatmap(),
            ),
          ),
          const SizedBox(height: 24),

          // Penggunaan Stok by Group dengan pie chart
          AppCard(
            title: 'Penggunaan Stok bahan by Group',
            action: const AppText(
              'Hari ini',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: StockUsageChart(
                    data: controller.stockUsageData,
                    isDoughnut: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Floating Action Button di bottom untuk mengakses menu Catat stok masuk
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: 'Catat stok masuk',
              prefixSvgPath: AppIcons.add,
              variant: ButtonVariant.primary,
              onPressed: () {
                Get.toNamed(Routes.STOCK_IN);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
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
          const AppText('Periode Data'),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0E5937),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const AppText('Real-time', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          const AppText('Hari ini - Pk 00:00 (GMT+07)'),
          const Spacer(),
          const Icon(Icons.calendar_today, size: 18),
        ],
      ),
    );
  }

  // Placeholder widget untuk heatmap penggunaan stok
  Widget _buildStockUsageHeatmap() {
    // Implementasi heatmap
    return Container(color: Colors.grey.shade100);
  }
}
