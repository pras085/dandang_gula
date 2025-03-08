import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global_widgets/layout/app_layout.dart';
import '../../controllers/dashboard_controller.dart';
import '../admin_view.dart';
import '../branch_manager_view.dart';
import '../gudang_view.dart';
import '../kasir_view.dart';
import '../pusat_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return AppLayout(
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Route ke view yang sesuai berdasarkan role
      switch (controller.userRole.value) {
        case 'admin':
          return AppLayout(
            body: AdminDashboardView(controller: controller),
          );
        case 'pusat':
          return AppLayout(
            body: PusatDashboardView(controller: controller),
          );
        case 'branchmanager':
          return AppLayout(
            body: SupervisorDashboardView(controller: controller),
          );
        case 'kasir':
          // Kasir view memiliki layout khusus, sehingga tidak menggunakan AppLayout
          return KasirDashboardView(controller: controller);
        case 'gudang':
          return AppLayout(
            body: GudangDashboardView(controller: controller),
          );
        default:
          return AppLayout(
            body: Center(
              child: Text('Role tidak valid: ${controller.userRole.value}'),
            ),
          );
      }
    });
  }
}
