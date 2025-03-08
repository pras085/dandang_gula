
import 'package:get/get.dart';
import '../core/middleware/auth_middleware.dart';

// Common modules
import '../modules/common/dashboard/views/components/dashboard_view.dart';
import '../modules/common/login/bindings/login_binding.dart';
import '../modules/common/login/views/login_view.dart';
import '../modules/common/dashboard/bindings/dashboard_binding.dart';
// import '../modules/common/dashboard/views/dashboard_view.dart';
// import '../modules/common/reports/bindings/reports_binding.dart';
// import '../modules/common/reports/views/reports_view.dart';
// import '../modules/common/profile/bindings/profile_binding.dart';
// import '../modules/common/profile/views/profile_view.dart';

// Branch management
// import '../modules/common/branch_management/bindings/branch_management_binding.dart';
// import '../modules/common/branch_management/views/branch_management_view.dart';

// User management
// import '../modules/common/user_management/bindings/user_management_binding.dart';
// import '../modules/common/user_management/views/user_management_view.dart';

// Inventory
// import '../modules/common/inventory/bindings/inventory_binding.dart';
// import '../modules/common/inventory/views/inventory_view.dart';
// import '../modules/common/inventory/views/stock_in_view.dart';
// import '../modules/common/inventory/views/stock_out_view.dart';

// Orders
// import '../modules/common/orders/bindings/orders_binding.dart';
// import '../modules/common/orders/views/orders_view.dart';
// import '../modules/common/orders/views/new_order_view.dart';
// import '../modules/common/orders/views/order_details_view.dart';

// Attendance
// import '../modules/common/attendance/bindings/attendance_binding.dart';
// import '../modules/common/attendance/views/attendance_view.dart';

// Menu management
// import '../modules/branch_manager/menu_management/bindings/menu_management_binding.dart';
// import '../modules/branch_manager/menu_management/views/menu_management_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Auth routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // Common routes
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    // GetPage(
    //   name: Routes.REPORTS,
    //   page: () => ReportsView(),
    //   binding: ReportsBinding(),
    //   middlewares: [AuthMiddleware()],
    // ),
    // GetPage(
    //   name: Routes.PROFILE,
    //   page: () => ProfileView(),
    //   binding: ProfileBinding(),
    //   middlewares: [AuthMiddleware()],
    // ),
    // GetPage(
    //   name: Routes.NOTIFICATIONS,
    //   page: () => NotificationsView(),
    //   binding: NotificationsBinding(),
    //   middlewares: [AuthMiddleware()],
    // ),

    // // Branch management (admin & pusat)
    // GetPage(
    //   name: Routes.BRANCH_MANAGEMENT,
    //   page: () => BranchManagementView(),
    //   binding: BranchManagementBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['admin', 'pusat']),
    //   ],
    // ),

    // // User management (admin, pusat & branch manager)
    // GetPage(
    //   name: Routes.USER_MANAGEMENT,
    //   page: () => UserManagementView(),
    //   binding: UserManagementBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['admin', 'pusat', 'branchmanager']),
    //   ],
    // ),

    // // Inventory (gudang & branch manager)
    // GetPage(
    //   name: Routes.INVENTORY,
    //   page: () => InventoryView(),
    //   binding: InventoryBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.STOCK_IN,
    //   page: () => StockInView(),
    //   binding: InventoryBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.STOCK_OUT,
    //   page: () => StockOutView(),
    //   binding: InventoryBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['gudang', 'branchmanager']),
    //   ],
    // ),

    // // Orders (kasir & branch manager)
    // GetPage(
    //   name: Routes.ORDERS,
    //   page: () => OrdersView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.NEW_ORDER,
    //   page: () => NewOrderView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),
    // GetPage(
    //   name: Routes.ORDER_DETAILS,
    //   page: () => OrderDetailsView(),
    //   binding: OrdersBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir', 'branchmanager']),
    //   ],
    // ),

    // // Attendance (kasir only)
    // GetPage(
    //   name: Routes.ATTENDANCE,
    //   page: () => AttendanceView(),
    //   binding: AttendanceBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['kasir']),
    //   ],
    // ),

    // // Menu management (branch manager only)
    // GetPage(
    //   name: Routes.MENU_MANAGEMENT,
    //   page: () => MenuManagementView(),
    //   binding: MenuManagementBinding(),
    //   middlewares: [
    //     AuthMiddleware(allowedRoles: ['branchmanager']),
    //   ],
    // ),
  ];

  static final initialRoute = Routes.LOGIN;
}
