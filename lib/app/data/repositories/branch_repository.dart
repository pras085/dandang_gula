import '../models/branch_model.dart';
import '../models/chart_data_model.dart';
import '../models/revenue_expense_data.dart';

abstract class BranchRepository {
  Future<List<Branch>> getAllBranches();
  Future<Branch> getBranchById(String id);
  Future<Map<String, double>> getBranchRevenue(String id);
  Future<List<ChartData>> getBranchRevenueChartData(String id);
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id);
}

class BranchRepositoryImpl implements BranchRepository {
  @override
  Future<List<Branch>> getAllBranches() async {
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
      Branch(
        id: '4',
        name: 'Ngelaras Rasa Kuningan',
        address: 'Jl. HR. Rasuna Said Kav. C22',
        phone: '021-5208762',
        email: 'kuningan@ngelarasrasa.com',
        managerId: '104',
        managerName: 'Ade Suratman',
      ),
    ];
  }

  @override
  Future<Branch> getBranchById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would fetch the specific branch from API
    final branches = await getAllBranches();
    return branches.firstWhere((branch) => branch.id == id);
  }

  @override
  Future<Map<String, double>> getBranchRevenue(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock different revenue values for each branch
    final branchRevenues = {
      '1': 10000000.0,
      '2': 10000000.0,
      '3': 10000000.0,
      '4': 8000000.0,
    };

    return {
      'revenue': branchRevenues[id] ?? 0.0,
      'cogs': 45000000.0,
      'netProfit': 5000000.0,
      'growth': -9.75,
    };
  }

  @override
  Future<List<ChartData>> getBranchRevenueChartData(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final data = <ChartData>[];

    // Generate sample data with slight variations per branch
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

  @override
  Future<List<RevenueExpenseData>> getBranchRevenueExpenseData(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final data = <RevenueExpenseData>[];

    // Generate sample data with variations per branch
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
