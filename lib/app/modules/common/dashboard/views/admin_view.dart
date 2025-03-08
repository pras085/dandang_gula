import 'package:flutter/material.dart';
import '../../../../global_widgets/table/payment_method_table.dart';
import '../../../../global_widgets/table/product_sales_table.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../global_widgets/charts/revenue_chart.dart';
import '../../../../global_widgets/charts/category_chart.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/card/summary_card.dart';

class AdminDashboardView extends StatelessWidget {
  final DashboardController controller;

  const AdminDashboardView({super.key, required this.controller});

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
            // Tab View selector untuk Penjualan / Inventori Gudang
            _buildTabSelector(),
            const SizedBox(height: 16),

            // Period selector (tampilan filter)
            _buildPeriodSelector(),
            const SizedBox(height: 24),

            // Row dengan StatCards untuk data penjualan
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Pendapatan',
                    value: 'Rp 50.000.000',
                    subtitle: 'Total',
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row dengan detail COGS dan Laba Kotor
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
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              AppText(
                                'Rp 45.000.000',
                                style: Theme.of(context).textTheme.titleMedium,
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
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              AppText(
                                'Rp 5.000.000',
                                style: Theme.of(context).textTheme.titleMedium,
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
            const SizedBox(height: 16),

            // Total Pesanan
            const SummaryCard(
              title: 'Total Pesanan',
              value: '1,520 Pesanan',
              subtitle: 'Total',
              icon: Icons.receipt,
            ),
            const SizedBox(height: 24),

            // Grafik Total Pendapatan
            AppCard(
              title: 'Total Pendapatan',
              child: SizedBox(
                height: 250,
                child: RevenueChart(
                  data: controller.salesData,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Penjualan Produk
            ProductSalesTable(
              title: 'Penjualan Produk',
              products: controller.productSales,
              onViewAll: () {
                // Action untuk melihat semua produk
              },
            ),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: CategoryChart(
                            data: controller.categorySales,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Pendapatan by Metode Pembayaran
                Expanded(
                  child: PaymentMethodTable(
                    title: 'Pendapatan by Metode Pembayaran',
                    paymentMethods: controller.paymentMethods,
                    onViewAll: () {
                      // Action untuk melihat semua metode pembayaran
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Download Data button
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download Data'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0E5937)),
                  foregroundColor: const Color(0xFF0E5937),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0E5937),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const AppText(
                'Penjualan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const AppText(
                'Inventori Gudang',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
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
}
