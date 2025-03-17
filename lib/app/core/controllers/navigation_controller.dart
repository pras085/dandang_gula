import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class NavigationController extends GetxController {
  final Rx<String> currentRoute = Routes.DASHBOARD.obs;

  void changePage(String routeName) {
    if (currentRoute.value != routeName) {
      currentRoute.value = routeName;

      // Use appropriate GetX navigation based on route
      switch (routeName) {
        case Routes.DASHBOARD:
        case Routes.BRANCH_MANAGEMENT:
        case Routes.USER_MANAGEMENT:
        case Routes.REPORTS:
          // For main content areas, use Get.toNamed with no animation
          Get.toNamed(
            routeName,
            preventDuplicates: true,
          );
          break;

        case Routes.LOGIN:
        case Routes.SETTING:
          // For screens that should replace current view, use normal navigation
          Get.toNamed(routeName);
          break;

        default:
          Get.toNamed(
            routeName,
            preventDuplicates: true,
          );
      }
    }
  }
}
