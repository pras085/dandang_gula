import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/config/theme/app_theme.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation for tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize the AuthService
  final authService = Get.put(AuthService(), permanent: true);
  // Wait for the AuthService to initialize fully (loading from SharedPreferences)
  // await Future.delayed(const Duration(milliseconds: 500));

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({
    super.key,
    required this.authService,
  });
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dandang Gula Restaurant Management',
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.fade,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    // Check if user is logged in and determine the appropriate route
    if (authService.isLoggedIn) {
      return Routes.DASHBOARD;
    } else {
      return Routes.LOGIN;
    }
  }
}
