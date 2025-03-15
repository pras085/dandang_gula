import 'package:get/get.dart';
import '../models/branch_model.dart';
import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';
import '../services/api_service.dart';

abstract class BranchRepository {
  RxList<Branch> get branches;
  Future<void> fetchAllBranches();
  Branch? getBranchById(String id);
  Future<void> addBranch(Branch branch);
  Future<void> updateBranch(Branch branch);
  Future<void> deleteBranch(String id);
  Future<Map<String, double>> getBranchRevenue(String id);
  Future<List<ChartData>> getBranchRevenueChartData(String id);
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id);
}

class BranchRepositoryImpl extends BranchRepository {
  final ApiService _apiService = Get.find<ApiService>();

  // Observable list of branches
  @override
  final RxList<Branch> branches = <Branch>[].obs;

  // Fetch all branches
  @override
  Future<void> fetchAllBranches() async {
    try {
      final response = await _apiService.get('/branches');

      final List<Branch> branchList = (response as List).map((item) => Branch.fromJson(item)).toList();

      branches.assignAll(branchList);
    } catch (e) {
      // Handle error
      print('Error fetching branches: $e');

      // Fallback to mock data if API fails
      _loadMockBranchData();
    }
  }

  // Load mock data as fallback
  void _loadMockBranchData() {
    final List<Branch> branchList = [
      Branch(
        id: '1',
        name: 'Kedai Dandang Gula MT. Haryono',
        address: 'Jl. MT. Haryono No. 10',
        phone: '021-1234567',
        email: 'haryono@dandanggula.com',
        managerId: '101',
        managerName: 'Joe Heiden',
        income: 10000000,
        cogs: 45000000,
        netProfit: 5000000,
        percentChange: -9.75,
      ),
      Branch(
        id: '2',
        name: 'Kedai Dandang Gula Margonda',
        address: 'Jl. Margonda Raya No. 525',
        phone: '021-8765432',
        email: 'margonda@dandanggula.com',
        managerId: '102',
        managerName: 'Martha Elbert',
        income: 12000000,
        cogs: 48000000,
        netProfit: 6000000,
        percentChange: 5.25,
      ),
      Branch(
        id: '3',
        name: 'Kedai Dandang Gula ',
        address: 'Jl. Margonda Raya No. 525',
        phone: '021-8765432',
        email: 'margonda@dandanggula.com',
        managerId: '102',
        managerName: 'Martha Elbert',
        income: 12000000,
        cogs: 48000000,
        netProfit: 6000000,
        percentChange: 5.25,
      ),
      // Add more mock data as needed
    ];

    branches.assignAll(branchList);
  }

  // Get a branch by ID
  @override
  Branch? getBranchById(String id) {
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      // No branch found with the given ID
      return null;
    }
  }

  // Add a new branch
  @override
  Future<void> addBranch(Branch branch) async {
    try {
      final response = await _apiService.post(
        '/branches',
        body: branch.toJson(),
      );

      // Add the new branch with the ID from the server
      final newBranch = Branch.fromJson(response);
      branches.add(newBranch);
    } catch (e) {
      print('Error adding branch: $e');

      // Fallback for demo/development
      branches.add(branch);
    } finally {
      branches.refresh();
    }
  }

  // Update a branch
  @override
  Future<void> updateBranch(Branch branch) async {
    try {
      await _apiService.put(
        '/branches/${branch.id}',
        body: branch.toJson(),
      );

      final index = branches.indexWhere((b) => b.id == branch.id);
      if (index != -1) {
        branches[index] = branch;
      }
    } catch (e) {
      print('Error updating branch: $e');

      // Fallback for demo/development
      final index = branches.indexWhere((b) => b.id == branch.id);
      if (index != -1) {
        branches[index] = branch;
      }
    } finally {
      branches.refresh();
    }
  }

  // Delete a branch
  @override
  Future<void> deleteBranch(String id) async {
    try {
      await _apiService.delete('/branches/$id');
      branches.removeWhere((branch) => branch.id == id);
    } catch (e) {
      print('Error deleting branch: $e');

      // Fallback for demo/development
      branches.removeWhere((branch) => branch.id == id);
    } finally {
      branches.refresh();
    }
  }

  @override
  Future<Map<String, double>> getBranchRevenue(String id) async {
    try {
      final response = await _apiService.get('/branches/$id/revenue');

      return {
        'revenue': response['revenue'] ?? 0.0,
        'cogs': response['cogs'] ?? 0.0,
        'netProfit': response['netProfit'] ?? 0.0,
        'growth': response['growth'] ?? 0.0,
      };
    } catch (e) {
      print('Error fetching branch revenue: $e');

      // Fallback with mock data
      final branch = getBranchById(id);
      if (branch != null) {
        return {
          'revenue': branch.income,
          'cogs': branch.cogs,
          'netProfit': branch.netProfit,
          'growth': branch.percentChange,
        };
      }

      return {
        'revenue': 0.0,
        'cogs': 0.0,
        'netProfit': 0.0,
        'growth': 0.0,
      };
    } finally {
      branches.refresh();
    }
  }

  @override
  Future<List<ChartData>> getBranchRevenueChartData(String id) async {
    try {
      final response = await _apiService.get('/branches/$id/chart');

      return (response as List).map((item) => ChartData.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching branch revenue chart data: $e');

      // Fallback to mock data
      final data = <ChartData>[];
      final int seedMultiplier = int.parse(id);

      for (int i = 1; i <= 8; i++) {
        data.add(ChartData(
          label: 'Jan $i',
          value: 5000000 + (i * 300000 * (i % 4 == 0 ? -1 : 1)) * (seedMultiplier * 0.2),
          date: DateTime(2023, 1, i),
        ));
      }

      return data;
    }
  }

  @override
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id) async {
    try {
      final response = await _apiService.get('/branches/$id/revenue-expense');

      return (response as List).map((item) => RevenueExpenseData.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching branch revenue expense data: $e');

      // Fallback to mock data
      final data = <RevenueExpenseData>[];
      final int seedMultiplier = int.parse(id);

      for (int i = 1; i <= 8; i++) {
        data.add(RevenueExpenseData(
          date: DateTime(2023, 1, i + 10),
          revenue: 1500000 + (i * 100000 * (seedMultiplier * 0.2)),
          expense: 1000000 + (i * 50000 * (i % 3 == 0 ? 1.2 : 0.8) * (seedMultiplier * 0.15)),
        ));
      }

      return data;
    }
  }
}
