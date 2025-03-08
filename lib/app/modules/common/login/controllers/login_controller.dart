import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../global_widgets/alert/app_snackbar.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final idLokasiController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Form validation
  final RxString idLokasiError = ''.obs;
  final RxString usernameError = ''.obs;
  final RxString passwordError = ''.obs;

  // UI state
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isMasterAdmin = false.obs;
  final RxBool obscurePassword = true.obs;

  // Selected role
  final RxString selectedRole = 'admin'.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void toggleMasterAdmin(bool? value) {
    isMasterAdmin.value = value ?? false;
    // If master admin is selected, set role to 'pusat'
    if (isMasterAdmin.value) {
      selectedRole.value = 'pusat';
    } else {
      selectedRole.value = 'admin';
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validateForm() {
    bool isValid = true;

    //Validate masterAdmin
    if (isMasterAdmin.value && idLokasiController.text.isEmpty) {
      idLokasiError.value = 'ID Lokasi is required';
      isValid = false;
    } else {
      idLokasiError.value = '';
    }

    // Validate username
    if (usernameController.text.isEmpty) {
      usernameError.value = 'Username is required';
      isValid = false;
    } else {
      usernameError.value = '';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final success = await _authService.login(
        usernameController.text,
        passwordController.text,
        selectedRole.value,
      );

      if (success) {
        // Navigate to appropriate dashboard based on role
        _navigateBasedOnRole();
      } else {
        AppSnackBar.error(
          message: "Invalid username or password",
        );
      }
    } catch (e) {
      AppSnackBar.error(
        message: "An error occurred during login",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateBasedOnRole() {
    Get.offAllNamed(Routes.DASHBOARD);
  }

  void goToForgotPassword() {
    debugPrint('Forgot password');
    // Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
