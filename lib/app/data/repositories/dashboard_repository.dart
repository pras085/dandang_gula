import 'package:get/get.dart';

import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';
import '../services/api_service.dart';
import 'branch_repository.dart';

class DashboardSummary {
  final double totalIncome;
  final double netProfit;
  final double percentChange;

  DashboardSummary({
    required this.totalIncome,
    required this.netProfit,
    required this.percentChange,
  });
}

abstract class DashboardRepository {
  // Observable values
  Rx<DashboardSummary> get dashboardSummary;
  RxList<ChartData> get incomeChartData;
  RxList<RevenueExpenseData> get revenueExpenseData;

  // Methods
  Future<DashboardSummary> fetchDashboardSummary({Map<String, dynamic>? filterParams});
  Future<void> fetchRevenueExpenseData(String branchId, {Map<String, dynamic>? filterParams});
  Future<void> fetchSalesPerformanceData(String branchId, {Map<String, dynamic>? filterParams});
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams});
  Future<double> getTotalProfit({Map<String, dynamic>? filterParams});
  Future<double> getRevenueGrowth({Map<String, dynamic>? filterParams});
  Future<List<ChartData>> getRevenueChartData({Map<String, dynamic>? filterParams});
}

class DashboardRepositoryImpl implements DashboardRepository {
  final BranchRepository _branchRepository = Get.find<BranchRepository>();
  final ApiService? _apiService = Get.isRegistered<ApiService>() ? Get.find<ApiService>() : null;

  // Cache data per branch
  final _salesPerformanceCache = <String, List<ChartData>>{};

  // Observable values
  @override
  final dashboardSummary = Rx<DashboardSummary>(
    DashboardSummary(
      totalIncome: 0,
      netProfit: 0,
      percentChange: 0,
    ),
  );

  @override
  final incomeChartData = <ChartData>[].obs;

  @override
  final revenueExpenseData = <RevenueExpenseData>[].obs;

  // Fetch dashboard summary data
  @override
  Future<DashboardSummary> fetchDashboardSummary({Map<String, dynamic>? filterParams}) async {
    try {
      if (_apiService != null) {
        // Try to fetch from API
        final response = await _apiService.get('/dashboard/summary');

        dashboardSummary.value = DashboardSummary(
          totalIncome: response['totalIncome'] ?? 0.0,
          netProfit: response['netProfit'] ?? 0.0,
          percentChange: response['percentChange'] ?? 0.0,
        );
        return dashboardSummary.value;
      }
    } catch (e) {
      print('Error fetching dashboard summary: $e');
      // Fallback to mock data
      await Future.delayed(const Duration(milliseconds: 500));
      dashboardSummary.value = DashboardSummary(
        totalIncome: 50000000,
        netProfit: 3000000,
        percentChange: -9.75,
      );
    } finally {
      dashboardSummary.refresh();
    }
    return dashboardSummary.value;
  }

  // Fetch revenue vs expense data for a specific branch
  @override
  Future<void> fetchRevenueExpenseData(String branchId, {Map<String, dynamic>? filterParams}) async {
    try {
      final data = await _branchRepository.getBranchRevenueExpenseData(
        branchId,
        filterParams: filterParams,
      );
      revenueExpenseData.value = data;
    } catch (e) {
      print('Error fetching revenue expense data: $e');
      revenueExpenseData.value = _getDefaultRevenueExpenseData(branchId);
    }
  }

  // Helper method to create mock revenue/expense data
  List<RevenueExpenseData> _getDefaultRevenueExpenseData(String branchId) {
    final data = <RevenueExpenseData>[];
    final int seedMultiplier = int.tryParse(branchId) ?? 1;

    for (int i = 1; i <= 8; i++) {
      data.add(RevenueExpenseData(
        date: DateTime(2023, 1, i + 10),
        revenue: 1500000 + (i * 100000 * (seedMultiplier * 0.2)),
        expense: 1000000 + (i * 50000 * (i % 3 == 0 ? 1.2 : 0.8) * (seedMultiplier * 0.15)),
      ));
    }

    return data;
  }

  // Fetch sales performance data for a specific branch
  @override
  Future<void> fetchSalesPerformanceData(String branchId, {Map<String, dynamic>? filterParams}) async {
    try {
      // Return cached data if available
      if (_salesPerformanceCache.containsKey(branchId)) {
        incomeChartData.value = _salesPerformanceCache[branchId]!;
        return;
      }

      // Try to fetch from API
      if (_apiService != null) {
        try {
          final response = await _apiService.get('/dashboard/sales-performance/$branchId', queryParams: filterParams);
          final data = (response as List).map((item) => ChartData.fromJson(item)).toList();

          _salesPerformanceCache[branchId] = data;
          incomeChartData.value = data;
          return;
        } catch (e) {
          print('API error, falling back to repository: $e');
        }
      }

      // Fallback to branch repository
      try {
        final data = await _branchRepository.getBranchRevenueChartData(
          branchId,
          filterParams: filterParams,
        );
        if (data.isNotEmpty) {
          _salesPerformanceCache[branchId] = data;
          incomeChartData.value = data;
          return;
        }
      } catch (e) {
        print('Repository error, falling back to mock data: $e');
      }

      // Fallback to mock data if both API and repository fail
      final mockData = _getDefaultSalesPerformanceData(branchId);
      _salesPerformanceCache[branchId] = mockData;
      incomeChartData.value = mockData;
    } catch (e) {
      print('Error fetching sales performance data: $e');
      // Ensure we always have data by setting mock data on any error
      incomeChartData.value = _getDefaultSalesPerformanceData(branchId);
    }
  }

// Helper method to create mock sales performance data
  List<ChartData> _getDefaultSalesPerformanceData(String branchId) {
    final data = <ChartData>[];
    final int seedMultiplier = int.tryParse(branchId) ?? 1;

    for (int i = 1; i <= 8; i++) {
      data.add(ChartData(
        label: '$i',
        value: 1500000 + (i * 100000 * (seedMultiplier * 0.2) * (i % 3 == 0 ? 0.8 : 1.2)),
        date: DateTime(2023, 1, i + 10),
      ));
    }

    return data;
  }

  @override
  Future<double> getTotalRevenue({Map<String, dynamic>? filterParams}) async {
    try {
      if (_apiService != null) {
        final response = await _apiService.get(
          '/dashboard/total-revenue',
          queryParams: filterParams,
        );
        return response['revenue'] ?? 0.0;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      return 50000000;
    } catch (e) {
      print('Error fetching total revenue: $e');
      return 0.0;
    }
  }

  @override
  Future<double> getTotalProfit({Map<String, dynamic>? filterParams}) async {
    try {
      if (_apiService != null) {
        final response = await _apiService.get(
          '/dashboard/total-profit',
          queryParams: filterParams,
        );
        return response['profit'] ?? 0.0;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      return 3000000;
    } catch (e) {
      print('Error fetching total profit: $e');
      return 0.0;
    }
  }

  @override
  Future<double> getRevenueGrowth({Map<String, dynamic>? filterParams}) async {
    try {
      if (_apiService != null) {
        final response = await _apiService.get(
          '/dashboard/revenue-growth',
          queryParams: filterParams,
        );
        return response['growth'] ?? 0.0;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      return -9.75;
    } catch (e) {
      print('Error fetching revenue growth: $e');
      return 0.0;
    }
  }

  @override
  Future<List<ChartData>> getRevenueChartData({Map<String, dynamic>? filterParams}) async {
    try {
      if (_apiService != null) {
        final response = await _apiService.get(
          '/dashboard/revenue-chart',
          queryParams: filterParams,
        );
        return (response as List).map((item) => ChartData.fromJson(item)).toList();
      }

      await Future.delayed(const Duration(milliseconds: 500));
      final data = <ChartData>[];

      // Generate sample data
      for (int i = 1; i <= 8; i++) {
        data.add(ChartData(
          label: 'Jan $i',
          value: 10000000 + (i * 500000 * (i % 3 == 0 ? -1 : 1)),
        ));
      }

      return data;
    } catch (e) {
      print('Error fetching revenue chart data: $e');
      return [];
    }
  }
}
