import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandang_gula/app/global_widgets/buttons/toogle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../global_widgets/input/app_text_field.dart';
import '../../../../global_widgets/text/app_text.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return ColoredBox(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              // Left side with background image
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // Cached network image
                    CachedNetworkImage(
                      imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                      ),
                    ),

                    // Overlay hijau
                    Positioned.fill(
                      child: Container(
                        color: AppColors.secondary.withOpacity(0.4),
                        // Menggunakan warna secondary (hijau) dari app_colors.dart
                      ),
                    ),

                    Positioned(
                      top: 16,
                      left: 26,
                      child: Image.asset(
                        'assets/icons/logo-dandang-gula.png',
                        width: 104,
                        height: 104,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side with login form
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Login title
                          AppText(
                            'Nice to see you again.',
                            style: AppTextStyles.codeText.copyWith(
                              color: AppColors.black1,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Master admin toggle
                          Row(
                            children: [
                              Obx(() => ToogleButton(
                                    value: controller.isMasterAdmin.value,
                                    onChanged: controller.toggleMasterAdmin,
                                    activeColor: const Color(0xFF23C368),
                                    inactiveColor: const Color(0xFFF2F2F2),
                                  )),
                              const SizedBox(width: 8),
                              Text(
                                'Masuk sebagai ${controller.isMasterAdmin.value ? "Master Admin" : "Branch Admin"}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Obx(() {
                            if (!controller.isMasterAdmin.value) return const SizedBox();
                            return Column(
                              children: [
                                AppTextField(
                                  label: 'ID lokasi',
                                  hint: 'Masukan id lokasi',
                                  controller: controller.idLokasiController,
                                  errorText: controller.idLokasiError.value.isEmpty ? null : controller.idLokasiError.value,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          }),

                          // Username field
                          Obx(() {
                            return AppTextField(
                              label: 'Username',
                              hint: 'Username',
                              controller: controller.usernameController,
                              errorText: controller.usernameError.value.isEmpty ? null : controller.usernameError.value,
                              keyboardType: TextInputType.text,
                            );
                          }),

                          const SizedBox(height: 24),

                          // Password field
                          Obx(() {
                            return AppTextField(
                              label: 'Password',
                              hint: 'Enter password',
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword.value,
                              errorText: controller.passwordError.value.isEmpty ? null : controller.passwordError.value,
                              suffixIcon: controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                              onSuffixIconTap: controller.togglePasswordVisibility,
                            );
                          }),
                          const SizedBox(height: 20),

                          // Remember me and forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Obx(() => Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: controller.toggleRememberMe,
                                        activeColor: AppColors.primary,
                                      )),
                                  AppText(
                                    'Remember me',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: controller.goToForgotPassword,
                                child: AppText(
                                  'Forgot password?',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Login button
                          Obx(() => ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : AppText(
                                        'Sign in',
                                        style: AppTextStyles.buttonLarge.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                              )),
                          const SizedBox(height: 24),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.language,
                                size: 18,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 8),
                              AppText(
                                'funtech.space',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                              const Spacer(),
                              AppText(
                                '© CV Fun teknologi 2025',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
