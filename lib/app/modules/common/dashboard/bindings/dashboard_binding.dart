import 'package:get/get.dart';
import '../../../../data/repositories/branch_repository.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/inventory_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../data/services/auth_service.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<BranchRepository>(() => BranchRepository());
    Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl());
    Get.lazyPut<InventoryRepository>(() => InventoryRepositoryImpl());

    // Services
    Get.lazyPut<AuthService>(() => AuthService());

    // Controller
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
