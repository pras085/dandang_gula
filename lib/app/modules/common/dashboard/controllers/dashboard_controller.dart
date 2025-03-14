import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../data/models/category_sales_model.dart';
import '../../../../data/models/chart_data_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../data/models/product_sales_model.dart';
import '../../../../data/models/stock_alert_model.dart';
import '../../../../data/models/stock_flow_data_model.dart';
import '../../../../data/models/stock_usage_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/branch_repository.dart';
import '../../../../data/repositories/dashboard_repository.dart';
import '../../../../data/repositories/inventory_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../data/services/auth_service.dart';

class DashboardController extends GetxController {
  // Repositories
  final BranchRepository branchRepository = Get.find<BranchRepository>();
  final DashboardRepository dashboardRepository = Get.find<DashboardRepository>();
  final OrderRepository orderRepository = Get.find<OrderRepository>();
  final InventoryRepository inventoryRepository = Get.find<InventoryRepository>();
  final AuthService authService = Get.find<AuthService>();

  // Variabel observable (reactive)
  final isLoading = true.obs;
  final userData = Rxn<User>();
  final userRole = ''.obs;
  final RxString selectedBranchId = ''.obs;
  final RxString selectedPeriod = 'today'.obs;

  // Data untuk semua role
  final todaySales = 0.0.obs;
  final monthSales = 0.0.obs;
  final yearSales = 0.0.obs;

  // Data untuk admin/pusat/branch manager
  final totalBranches = 0.obs;
  final activeBranches = 0.obs;
  final totalEmployees = 0.obs;
  final salesData = <ChartData>[].obs;
  final categorySales = <CategorySales>[].obs;
  final productSales = <ProductSales>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;

  // Data untuk kasir
  final completedOrders = 0.obs;
  final pendingOrders = 0.obs;
  final attendanceRate = 0.0.obs;

  // Data untuk gudang
  final lowStockItems = 0.obs;
  final outOfStockItems = 0.obs;
  final lastRestockDate = Rxn<DateTime>();
  final stockAlerts = <StockAlert>[].obs;
  final stockFlowData = <StockFlowData>[].obs;
  final stockUsageData = <StockUsage>[].obs;

  // Cache for performance data
  final _salesPerformanceCache = <String, List<ChartData>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    // loadDashboardData();
    fetchInitialData();
  }

  void loadUserData() async {
    isLoading.value = true;
    try {
      userData.value = authService.currentUser;
      userRole.value = userData.value?.role ?? '';
      debugPrint('role : ${userRole.value}');
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchInitialData() async {
    // Fetch branches
    await branchRepository.fetchAllBranches();

    // Set default selected branch if available
    if (branchRepository.branches.isNotEmpty) {
      selectedBranchId.value = branchRepository.branches.first.id;
    }

    // Fetch dashboard summary data
    await dashboardRepository.fetchDashboardSummary();

    // Fetch income chart data
    // await dashboardRepository.fet();

    // Fetch revenue vs expense data for the selected branch
    await dashboardRepository.fetchRevenueExpenseData(selectedBranchId.value);
  }

  // Select a branch
  void selectBranch(String branchId) {
    selectedBranchId.value = branchId;
    // Update revenue vs expense data for the selected branch
    dashboardRepository.fetchRevenueExpenseData(branchId);
  }

  // Change period
  void changePeriod(String period) {
    selectedPeriod.value = period;
    // Refresh data for the new period
    fetchInitialData();
  }

  void loadDashboardData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Remove this in production

    try {
      // Mock data for development - replace with actual API calls
      // _loadMockData();

      // Load data sesuai role
      switch (userRole.value) {
        case 'admin':
        case 'pusat':
          await loadAdminData();
          break;
        case 'branch_manager':
          await loadBranchManagerData();
          break;
        case 'kasir':
          await loadKasirData();
          break;
        case 'gudang':
          await loadGudangData();
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading dashboard data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get sales performance data for a specific branch
  List<ChartData> getSalesPerformanceForBranch(String branchId) {
    // Check if we have cached data
    if (_salesPerformanceCache.value.containsKey(branchId)) {
      if (_salesPerformanceCache.value[branchId] != null) return _salesPerformanceCache.value[branchId]!;
      return [];
    }

    // Fetch data and cache it
    _fetchAndCacheSalesPerformance(branchId);

    // Return empty list while loading
    return [];
  }

  // Fetch and cache sales performance data
  Future<void> _fetchAndCacheSalesPerformance(String branchId) async {
    try {
      await dashboardRepository.fetchSalesPerformanceData(branchId);
      // _salesPerformanceCache.value[branchId] = data;
      _salesPerformanceCache.refresh();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching sales performance: $e');
      }
      _salesPerformanceCache.value[branchId] = [];
    }
  }

  Future<void> loadAdminData() async {
    // Pada implementasi nyata, Anda akan memanggil API untuk mendapatkan data
    todaySales.value = 50000000;
    monthSales.value = 1500000000;
    yearSales.value = 18000000000;

    totalBranches.value = 10;
    activeBranches.value = 8;
    totalEmployees.value = 120;
  }

  Future<void> loadBranchManagerData() async {
    // Data spesifik untuk branch manager
    todaySales.value = 5000000;
    monthSales.value = 150000000;
    yearSales.value = 1800000000;

    totalEmployees.value = 15;
  }

  Future<void> loadKasirData() async {
    // Data spesifik untuk kasir
    todaySales.value = 2000000;

    completedOrders.value = 45;
    pendingOrders.value = 5;
    attendanceRate.value = 95.5;
  }

  Future<void> loadGudangData() async {
    // Data spesifik untuk gudang
    lowStockItems.value = 8;
    outOfStockItems.value = 3;
    lastRestockDate.value = DateTime.now().subtract(const Duration(days: 2));
  }

  Future<void> refreshData() async {
    loadDashboardData();
  }
}
