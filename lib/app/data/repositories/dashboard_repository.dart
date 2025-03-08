import '../models/chart_data_model.dart';
import '../models/branch_model.dart';

abstract class DashboardRepository {
  Future<double> getTotalRevenue();
  Future<double> getTotalProfit();
  Future<double> getRevenueGrowth();
  Future<List<ChartData>> getRevenueChartData();
  Future<List<Branch>> getBranches();
  Future<List<ChartData>> getBranchRevenueData(String branchId);
}

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<double> getTotalRevenue() async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 500));
    return 50000000;
  }

  @override
  Future<double> getTotalProfit() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 3000000;
  }

  @override
  Future<double> getRevenueGrowth() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return -9.75;
  }

  @override
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

  @override
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
  
  @override
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

