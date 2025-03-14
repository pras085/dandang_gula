import 'package:get/get.dart';

import '../models/chart_data_model.dart';
import '../models/branch_model.dart';
import '../models/revenue_expense_data.dart';
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

class DashboardRepository {
  // TODO DEVELOP
  // final ApiService _apiService = Get.find<ApiService>();

  final BranchRepository _branchRepository = Get.find<BranchRepository>();

  // Observable values
  final Rx<DashboardSummary> dashboardSummary = Rx<DashboardSummary>(
    DashboardSummary(
      totalIncome: 0,
      netProfit: 0,
      percentChange: -20,
    ),
  );

  final RxList<ChartData> incomeChartData = <ChartData>[].obs;
  final RxList<RevenueExpenseData> revenueExpenseData = <RevenueExpenseData>[].obs;

  // Fetch dashboard summary data
  Future<void> fetchDashboardSummary() async {
    try {
      // In a real implementation, you would call the API service
      // final response = await _apiService.get('/dashboard/summary');

      // For demonstration, using dummy data
      await Future.delayed(const Duration(milliseconds: 500));

      // Update the observable with the fetched data
      dashboardSummary.value = DashboardSummary(
        totalIncome: 50000000,
        netProfit: 3000000,
        percentChange: -9.75,
      );
    } catch (e) {
      // Handle error
      print('Error fetching dashboard summary: $e');
    }
  }

  // Fetch revenue vs expense data for a specific branch
  Future<void> fetchRevenueExpenseData(String branchId) async {
    try {
      // This line ensures we get actual data for the selected branch
      final data = await _branchRepository.getBranchRevenueExpenseData(branchId);

      // Important: we need to update the observable
      revenueExpenseData.value = data;
    } catch (e) {
      print('Error fetching revenue expense data: $e');
      // Set empty list on error
      revenueExpenseData.value = [];
    }
  }

  // Fetch sales performance data for a specific branch
  Future<void> fetchSalesPerformanceData(String branchId) async {
    try {
      // In a real implementation, you would call the API service
      // final response = await _apiService.get('/dashboard/sales-performance/$branchId');

      // For demonstration, using dummy data
      final data = await _branchRepository.getBranchRevenueChartData(branchId);

      incomeChartData.value = data;

      // await Future.delayed(const Duration(milliseconds: 500));

      // return [
      //   ChartData(label: 'Senin', value: 1200000,),
      //   ChartData(label: 'Selasa', value: 1450000),
      //   ChartData(label: 'Rabu', value: 1300000),
      //   ChartData(label: 'Kamis', value: 1550000),
      //   ChartData(label: 'Jumat', value: 1800000),
      //   ChartData(label: 'Sabtu', value: 2100000),
      //   ChartData(label: 'Minggu', value: 1900000),
      // ];
    } catch (e) {
      // Handle error
      print('Error fetching sales performance data: $e');
      incomeChartData.value = [];
    }
  }

  Future<double> getTotalRevenue() async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 500));
    return 50000000;
  }

  Future<double> getTotalProfit() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 3000000;
  }

  Future<double> getRevenueGrowth() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return -9.75;
  }

  Future<List<ChartData>> getRevenueChartData() async {
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
  }

  Future<List<Branch>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Branch(
        id: '1',
        name: 'Kedai Dandang Gula MT. Haryono',
        address: 'Jl. MT. Haryono No. 10',
        phone: '021-1234567',
        email: 'haryono@dandanggula.com',
        managerId: '101',
        managerName: 'Joe Heiden',
      ),
      Branch(
        id: '2',
        name: 'Ngelaras Rasa MT. Haryono',
        address: 'Jl. MT. Haryono No. 15',
        phone: '021-1234568',
        email: 'haryono@ngelarasrasa.com',
        managerId: '102',
        managerName: 'Martha Elbert',
      ),
      Branch(
        id: '3',
        name: 'Ngelaras Rasa Thamrin',
        address: 'Jl. MH. Thamrin No. 25',
        phone: '021-1234569',
        email: 'thamrin@ngelarasrasa.com',
        managerId: '103',
        managerName: 'Jun Aizawa',
      ),
    ];
  }

  Future<List<ChartData>> getBranchRevenueData(String branchId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final data = <ChartData>[];

    // Generate sample data
    for (int i = 1; i <= 8; i++) {
      data.add(ChartData(
        label: 'Jan $i',
        value: 5000000 + (i * 300000 * (i % 4 == 0 ? -1 : 1)),
      ));
    }

    return data;
  }
}
