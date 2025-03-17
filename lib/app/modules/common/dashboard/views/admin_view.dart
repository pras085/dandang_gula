import 'package:dandang_gula/app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/layout/app_card.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/buttons/app_button.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/layout/tab_container.dart';
import '../../../../global_widgets/charts/revenue_chart.dart';
import '../../../../global_widgets/charts/category_chart.dart';
import '../../../../global_widgets/charts/stock_flow_chart.dart';
import '../../../../global_widgets/charts/stock_usage_chart.dart';
import '../../../../global_widgets/table/payment_method_table.dart';
import '../../../../global_widgets/table/product_sales_table.dart';
import '../../../../global_widgets/table/stock_alert_table.dart';
import '../../../../global_widgets/card/summary_card.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/filter/period_filter.dart';
import '../widgets/total_income_card.dart';
import '../widgets/revenue_expense_chart_card.dart';

class AdminDashboardView extends GetView<DashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TabItem(
        title: 'Penjualan',
        content: _buildSalesContent(),
        icon: Icons.monetization_on,
      ),
      TabItem(
        title: 'Inventori Gudang',
        content: _buildInventoryContent(),
        icon: Icons.inventory_2,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PeriodFilter(
            controller: controller.periodFilterController,
            onPeriodChanged: (periodId) {
              controller.onPeriodFilterChanged(periodId);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Tab container with the content tabs
        TabContainer(
          tabs: tabs,
          onTabChanged: (index) {
            // Handle tab changes if needed
            print('Tab changed to index $index');
          },
        ),
      ],
    );
  }

  // Sales content tab
  Widget _buildSalesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Income Card
          TotalIncomeCard(controller: controller),
          const SizedBox(height: 24),

          // Total Sales & Orders Overview
          Row(
            children: [
              Expanded(
                child: Obx(() => SummaryCard(
                      title: 'Total Pendapatan',
                      value: 'Rp ${controller.todaySales.value.toStringAsFixed(0)}',
                      subtitle: 'Total',
                      icon: Icons.attach_money,
                    )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => SummaryCard(
                      title: 'Total Pesanan',
                      value: '${controller.completedOrders.value} Pesanan',
                      subtitle: 'Total',
                      icon: Icons.receipt,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row with detail COGS and Laba Kotor
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'COGS',
                              style: AppTextStyles.bodySmall,
                            ),
                            AppText(
                              'Rp 45.000.000',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
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
                              style: AppTextStyles.bodySmall,
                            ),
                            AppText(
                              'Rp 5.000.000',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue vs Expense Chart Card
          RevenueExpenseChartCard(controller: controller),
          const SizedBox(height: 24),

          // Grafik Total Pendapatan
          AppCard(
            title: 'Total Pendapatan',
            child: SizedBox(
              height: 250,
              child: Obx(() => RevenueChart(
                    data: controller.salesData,
                  )),
            ),
          ),
          const SizedBox(height: 24),

          // Penjualan Produk
          Obx(() => ProductSalesTable(
                title: 'Penjualan Produk',
                products: controller.productSales,
                onViewAll: () {
                  // Action untuk melihat semua produk
                },
              )),
          const SizedBox(height: 24),

          // Two cards in a row: Penjualan by kategori & Pendapatan by Metode Pembayaran
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Penjualan by kategori
              Expanded(
                child: AppCard(
                  title: 'Penjualan by kategori',
                  action: Text(
                    'Hari ini',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Obx(() => CategoryChart(
                              data: controller.categorySales,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Pendapatan by Metode Pembayaran
              Expanded(
                child: Obx(() => PaymentMethodTable(
                      title: 'Pendapatan by Metode Pembayaran',
                      paymentMethods: controller.paymentMethods,
                      onViewAll: () {
                        // Action untuk melihat semua metode pembayaran
                      },
                    )),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Download Data button
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: 'Download Data',
              prefixSvgPath: AppIcons.add,
              variant: ButtonVariant.outline,
              onPressed: () {},
              fullWidth: false,
              width: 170,
              outlineBorderColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Inventory content tab
  Widget _buildInventoryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inventory stats
          Row(
            children: [
              Expanded(
                child: Obx(() => SummaryCard(
                      title: 'Total Bahan',
                      value: '${controller.totalBranches.value * 40}',
                      secondaryValue: 'Items',
                      icon: Icons.category,
                    )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => SummaryCard(
                      title: 'Stok Rendah',
                      value: '${controller.lowStockItems.value}',
                      secondaryValue: 'Items',
                      icon: Icons.warning,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stok Masuk & Stok Terbuang
          Row(
            children: [
              // Stok Masuk
              Expanded(
                child: AppCard(
                  title: 'Stok Masuk',
                  action: const AppText(
                    'Hari ini',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText('Jumlah items'),
                      AppText(
                        '15',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 8),
                      const AppText('Total'),
                      AppText(
                        'Rp 1.000.000',
                        style: AppTextStyles.h3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Stok Terbuang
              Expanded(
                child: AppCard(
                  title: 'Stok Terbuang',
                  action: const AppText(
                    'Hari ini',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
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
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Statistik arus stok
          AppCard(
            title: 'Statistik arus stok',
            action: const AppText('Hari ini - Pk 00:00 (GMT+07)'),
            child: SizedBox(
              height: 250,
              child: Obx(() => StockFlowChart(
                    data: controller.stockFlowData,
                  )),
            ),
          ),
          const SizedBox(height: 24),

          // Stock Alert
          Obx(() => StockAlertTable(
                title: 'Stock alert',
                stockAlerts: controller.stockAlerts,
                onViewAll: () {
                  // Action untuk melihat semua stock alert
                },
              )),
          const SizedBox(height: 24),

          // Penggunaan Stok by Group dengan pie chart
          AppCard(
            title: 'Penggunaan Stok bahan by Group',
            action: const AppText(
              'Hari ini',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Obx(() => StockUsageChart(
                        data: controller.stockUsageData,
                        isDoughnut: true,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Tambah Stok',
                prefixSvgPath: AppIcons.add,
                variant: ButtonVariant.primary,
                onPressed: () {
                  // Navigate to stock in page
                  Get.toNamed('/inventory/stock-in');
                },
                fullWidth: false,
                width: 150,
              ),
              const SizedBox(width: 16),
              AppButton(
                label: 'Download Laporan',
                prefixSvgPath: AppIcons.download,
                variant: ButtonVariant.outline,
                onPressed: () {},
                fullWidth: false,
                width: 180,
                outlineBorderColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
