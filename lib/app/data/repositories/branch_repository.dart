import 'package:get/get.dart';

import '../models/branch_model.dart';
import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';

class BranchRepository {
  // Observable list of branches
  final RxList<Branch> branches = <Branch>[].obs;

  // Fetch all branches
  Future<void> fetchAllBranches() async {
    try {
      // For demonstration, using dummy data
      await Future.delayed(const Duration(milliseconds: 500));

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
          name: 'Ngelaras Rasa MT. Haryono',
          address: 'Jl. MT. Haryono No. 15',
          phone: '021-1234568',
          email: 'haryono@ngelarasrasa.com',
          managerId: '103',
          managerName: 'Jun Aizawa',
          income: 9500000,
          cogs: 40000000,
          netProfit: 4500000,
          percentChange: -3.15,
        ),
        Branch(
          id: '4',
          name: 'Ngelaras Rasa Thamrin',
          address: 'Jl. MH. Thamrin No. 25',
          phone: '021-1234569',
          email: 'thamrin@ngelarasrasa.com',
          managerId: '104',
          managerName: 'Ade Suratman',
          income: 15000000,
          cogs: 60000000,
          netProfit: 7500000,
          percentChange: 8.2,
        ),
        Branch(
          id: '5',
          name: 'Ngelaras Rasa Kemang',
          address: 'Jl. Kemang Raya No. 88',
          phone: '021-7654321',
          email: 'kemang@ngelarasrasa.com',
          managerId: '105',
          managerName: 'Diana Putri',
          income: 11000000,
          cogs: 47000000,
          netProfit: 5500000,
          percentChange: 4.3,
        ),
      ];

      branches.assignAll(branchList);
    } catch (e) {
      // Handle error
      print('Error fetching branches: $e');
    }
  }

  // Get a branch by ID
  Branch? getBranchById(String id) {
    try {
      return branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      // No branch found with the given ID
      return null;
    }
  }

  // Add a new branch
  Future<void> addBranch(Branch branch) async {
    try {
      branches.add(branch);
    } catch (e) {
      print('Error adding branch: $e');
    }
  }

  // Update a branch
  Future<void> updateBranch(Branch branch) async {
    try {
      final index = branches.indexWhere((b) => b.id == branch.id);
      if (index != -1) {
        branches[index] = branch;
      }
    } catch (e) {
      print('Error updating branch: $e');
    }
  }

  // Delete a branch
  Future<void> deleteBranch(String id) async {
    try {
      branches.removeWhere((branch) => branch.id == id);
    } catch (e) {
      print('Error deleting branch: $e');
    }
  }

  Future<Map<String, double>> getBranchRevenue(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
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
  }

  Future<List<ChartData>> getBranchRevenueChartData(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

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

  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

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
