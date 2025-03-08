import 'package:flutter/material.dart';
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
  final DashboardRepository repository;
  final BranchRepository branchRepository;
  final OrderRepository orderRepository;
  final InventoryRepository inventoryRepository;
  final AuthService authService;

  // Variabel observable (reactive)
  final isLoading = true.obs;
  final userData = Rxn<User>();
  final userRole = ''.obs;

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

  DashboardController({
    required this.repository,
    required this.branchRepository,
    required this.orderRepository,
    required this.inventoryRepository,
    required this.authService,
  });

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadDashboardData();
  }

  void loadUserData() async {
    isLoading.value = true;
    try {
      userData.value = authService.currentUser;
      userRole.value = userData.value?.role ?? '';
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadDashboardData() async {
    isLoading.value = true;
    try {
      // Mock data for development - replace with actual API calls
      _loadMockData();

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
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data untuk pengembangan
  void _loadMockData() {
    // Sales data
    salesData.assignAll([
      ChartData(label: 'Jan', value: 1000),
      ChartData(label: 'Feb', value: 1200),
      ChartData(label: 'Mar', value: 900),
      ChartData(label: 'Apr', value: 1500),
      ChartData(label: 'May', value: 2000),
      ChartData(label: 'Jun', value: 1800),
    ]);

    // Category sales
    categorySales.assignAll([
      CategorySales(
        id: '1',
        name: 'Main Dish',
        amount: 30000000,
        percentage: 60.0,
        color: '#136C3A',
      ),
      CategorySales(
        id: '2',
        name: 'Soup',
        amount: 10000000,
        percentage: 20.0,
        color: '#1B9851',
      ),
      CategorySales(
        id: '3',
        name: 'Nusantara',
        amount: 5000000,
        percentage: 10.0,
        color: '#90EE90',
      ),
      CategorySales(
        id: '4',
        name: 'Grill & Steak',
        amount: 3000000,
        percentage: 6.0,
        color: '#136C3A',
      ),
      CategorySales(
        id: '5',
        name: 'Beverages',
        amount: 2000000,
        percentage: 4.0,
        color: '#AEDFF7',
      ),
    ]);

    // Product sales
    productSales.assignAll([
      ProductSales(
        id: '1',
        name: 'Ayam Hamoy',
        orderCount: 1000,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '2',
        name: 'Ayam Laos',
        orderCount: 520,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '3',
        name: 'Americano',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '2',
        categoryName: 'Beverages',
      ),
      ProductSales(
        id: '4',
        name: 'Mix Platter',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '1',
        categoryName: 'Main Dish',
      ),
      ProductSales(
        id: '5',
        name: 'French Fries',
        orderCount: 15,
        totalSales: 1500000,
        categoryId: '3',
        categoryName: 'Sides',
      ),
    ]);

    // Payment methods
    paymentMethods.assignAll([
      PaymentMethod(
        id: '1',
        name: 'Tunai / Cash',
        amount: 100530000,
        icon: Icons.attach_money,
      ),
      PaymentMethod(
        id: '2',
        name: 'QRIS',
        amount: 25530000,
        icon: Icons.qr_code,
      ),
      PaymentMethod(
        id: '3',
        name: 'EDC',
        amount: 12530000,
        icon: Icons.credit_card,
      ),
    ]);

    // Stock alerts
    stockAlerts.assignAll([
      StockAlert(
        id: '1',
        name: 'Daging Ayam',
        category: 'Protein',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.9,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '2',
        name: 'Selada',
        category: 'Sayuran',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.85,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '3',
        name: 'Susu Full Cream',
        category: 'Minuman',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.2,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '4',
        name: 'Tomat',
        category: 'Sayuran',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.7,
        unitId: '1',
        unitName: 'gram',
      ),
      StockAlert(
        id: '5',
        name: 'Telur Ayam',
        category: 'Protein',
        stock: 'Sisa stock',
        amount: '500gr',
        alertLevel: 0.8,
        unitId: '1',
        unitName: 'gram',
      ),
    ]);

// Stock flow data
    stockFlowData.assignAll([
      StockFlowData(date: '01/03', sales: 50, purchases: 70, wastage: 10),
      StockFlowData(date: '02/03', sales: 60, purchases: 50, wastage: 5),
      StockFlowData(date: '03/03', sales: 70, purchases: 40, wastage: 8),
      StockFlowData(date: '04/03', sales: 80, purchases: 60, wastage: 12),
      StockFlowData(date: '05/03', sales: 65, purchases: 55, wastage: 7),
      StockFlowData(date: '06/03', sales: 75, purchases: 45, wastage: 9),
      StockFlowData(date: '07/03', sales: 85, purchases: 65, wastage: 11),
    ]);

    // Stock usage data
    stockUsageData.assignAll([
      StockUsage(
        id: "1",
        category: 'Sayuran',
        percentage: 32.0,
        color: '#228B22',
      ),
      StockUsage(
        id: "2",
        category: 'Protein',
        percentage: 28.0,
        color: '#136C3A',
      ),
      StockUsage(
        id: "3",
        category: 'Minuman',
        percentage: 18.0,
        color: '#87CEEB',
      ),
      StockUsage(
        id: "4",
        category: 'Seafood',
        percentage: 12.0,
        color: '#20B2AA',
      ),
      StockUsage(
        id: "5",
        category: 'Bumbu',
        percentage: 10.0,
        color: '#90EE90',
      ),
    ]);
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

  void refreshData() {
    loadDashboardData();
  }
}
