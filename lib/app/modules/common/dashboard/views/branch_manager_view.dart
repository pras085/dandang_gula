import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../global_widgets/charts/revenue_chart.dart';
import '../../../../global_widgets/card/action_card.dart';
import '../../../../global_widgets/layout/app_layout.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../../../../global_widgets/card/summary_card.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class BranchManagerDashboardView extends StatelessWidget {
  final DashboardController controller;

  const BranchManagerDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab View selector untuk Penjualan / Inventori Gudang
          _buildTabSelector(),
          const SizedBox(height: 16),

          // Period selector (tampilan filter)
          _buildPeriodSelector(),
          const SizedBox(height: 24),

          // Total Pendapatan - sama dengan admin tetapi hanya untuk cabang yang dipimpin
          const SummaryCard(
            title: 'Total Pendapatan',
            value: 'Rp 50.000.000',
            subtitle: 'Total',
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),

          // Row dengan detail COGS dan Laba Kotor
          AppCard(
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('COGS'),
                      AppText(
                        'Rp 45.000.000',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('Laba Kotor'),
                      AppText(
                        'Rp 5.000.000',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Total Pesanan - sama dengan admin tetapi hanya untuk cabang yang dipimpin
          const SummaryCard(
            title: 'Total Pesanan',
            value: '1,520 Pesanan',
            subtitle: 'Total',
            icon: Icons.receipt,
          ),
          const SizedBox(height: 24),

          // Grafik Total Pendapatan - sama dengan admin tetapi hanya untuk cabang yang dipimpin
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

          // Section-section lainnya sama dengan admin
          // Hanya saja tautan menu ke halaman yang sesuai dengan akses Branch Manager

          // Tambahkan fitur yang spesifik untuk Branch Manager
          // Misalnya akses cepat ke Menu Management
          AppCard(
            title: 'Manajemen Menu',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionCard(
                  title: 'Kelola Menu',
                  icon: Icons.restaurant_menu,
                  onTap: () => Get.toNamed(Routes.MENU_MANAGEMENT),
                  color: AppColors.primary,
                ),
                ActionCard(
                  title: 'Kelola Stok',
                  icon: Icons.store,
                  onTap: () => Get.toNamed(Routes.INVENTORY),
                  color: AppColors.secondary,
                ),
                ActionCard(
                  title: 'Kelola Staff',
                  icon: Icons.people,
                  onTap: () => Get.toNamed(Routes.USER_MANAGEMENT),
                  color: AppColors.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menggunakan komponen yang sama dengan di AdminDashboardView
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
