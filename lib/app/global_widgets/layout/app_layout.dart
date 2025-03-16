import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandang_gula/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils.dart';
import '../../data/services/auth_service.dart';
import '../buttons/icon_button.dart';
import '../text/app_text.dart';

enum UserRole {
  admin,
  kasir,
  gudang,
  pusat,
  branchmanager,
}

class AppLayout extends StatelessWidget {
  final Widget content;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Future<void> Function()? onRefresh;

  // Get auth service for user role
  final AuthService _authService = Get.find<AuthService>();

  AppLayout({
    super.key,
    required this.content,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.onRefresh,
  });

  // Convert string role from AuthService to UserRole enum
  UserRole _getUserRoleEnum() {
    switch (_authService.userRole) {
      case 'admin':
        return UserRole.admin;
      case 'kasir':
        return UserRole.kasir;
      case 'gudang':
        return UserRole.gudang;
      case 'pusat':
        return UserRole.pusat;
      case 'branchmanager':
        return UserRole.branchmanager;
      default:
        return UserRole.kasir;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: onRefresh ?? () async {},
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // App Bar in a SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 24,
                      top: 12,
                      right: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavigation(),
                        const SizedBox(width: 12),
                        _buildUserProfile(),
                      ],
                    ),
                  ),
                ),

                // Content as SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: content,
                ),
              ],
            ),
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Expanded(
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardPadding),
        ),
        child: Row(
          children: [
            Image.asset(
              AppIcons.appIcon,
              height: 50,
              width: 50,
            ),
            const SizedBox(width: AppDimensions.spacing16),
            _buildNavigationItems(),
          ],
        ),
      ),
    );
  }

  // Different menu items based on user role
  Widget _buildNavigationItems() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          return Row(
            children: _getNavigationItemsByRole(),
          );
        }),
      ),
    );
  }

  List<Widget> _getNavigationItemsByRole() {
    final navItems = <Widget>[];
    final currentRole = _getUserRoleEnum();
    final currentRoute = Get.currentRoute;

    // Add Dashboard button for all roles
    navItems.add(
      _buildNavItem(
        'Dashboard',
        AppIcons.dashboard,
        currentRoute == Routes.DASHBOARD,
        () => Get.toNamed(Routes.DASHBOARD),
      ),
    );
    // Add role-specific menu items
    switch (currentRole) {
      case UserRole.admin:
        navItems.addAll([
          _buildNavItem(
            'Manajemen Cabang',
            AppIcons.orderDetails,
            currentRoute == Routes.BRANCH_MANAGEMENT,
            () => Get.toNamed(Routes.BRANCH_MANAGEMENT),
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            currentRoute == Routes.USER_MANAGEMENT,
            () => Get.toNamed(Routes.USER_MANAGEMENT),
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == Routes.REPORTS,
            () => Get.toNamed(Routes.REPORTS),
          ),
        ]);
        break;

      case UserRole.kasir:
        navItems.addAll([
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            currentRoute == Routes.ORDERS,
            () => Get.toNamed(Routes.ORDERS),
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == Routes.REPORTS,
            () => Get.toNamed(Routes.REPORTS),
          ),
          _buildNavItem(
            'Presensi',
            AppIcons.userAccess,
            currentRoute == Routes.ATTENDANCE,
            () => Get.toNamed(Routes.ATTENDANCE),
          ),
        ]);
        break;

      case UserRole.gudang:
        navItems.addAll([
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            currentRoute == Routes.STOCK_IN,
            () => Get.toNamed(Routes.STOCK_IN),
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == Routes.REPORTS,
            () => Get.toNamed(Routes.REPORTS),
          ),
        ]);
        break;

      case UserRole.pusat:
        navItems.addAll([
          _buildNavItem(
            'Manajemen Cabang',
            AppIcons.orderDetails,
            currentRoute == Routes.BRANCH_MANAGEMENT,
            () => Get.toNamed(Routes.BRANCH_MANAGEMENT),
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            currentRoute == Routes.USER_MANAGEMENT,
            () => Get.toNamed(Routes.USER_MANAGEMENT),
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == Routes.REPORTS,
            () => Get.toNamed(Routes.REPORTS),
          ),
        ]);
        break;

      case UserRole.branchmanager:
        navItems.addAll([
          _buildNavItem(
            'Management Menu',
            AppIcons.restaurant,
            currentRoute == Routes.MENU_MANAGEMENT,
            () => Get.toNamed(Routes.MENU_MANAGEMENT),
          ),
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            currentRoute == Routes.INVENTORY,
            () => Get.toNamed(Routes.INVENTORY),
          ),
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            currentRoute == Routes.ORDERS,
            () => Get.toNamed(Routes.ORDERS),
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            currentRoute == Routes.REPORTS,
            () => Get.toNamed(Routes.REPORTS),
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            currentRoute == Routes.USER_MANAGEMENT,
            () => Get.toNamed(Routes.USER_MANAGEMENT),
          ),
        ]);
        break;
    }

    return navItems;
  }

  Widget _buildNavItem(String label, String iconPath, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(
                        isActive ? AppColors.accent : AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isActive ? AppColors.accent : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Container dalam - hanya muncul saat aktif, untuk membuat efek inset
            if (isActive)
              Positioned(
                top: 2,
                left: 2,
                right: 2,
                bottom: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),

            // Content di atas container - pastikan tetap terlihat di atas efek inset
            if (isActive)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          iconPath,
                          colorFilter: const ColorFilter.mode(
                            AppColors.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        label,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          color: isActive ? AppColors.accent : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    // User avatar and profile
    return Obx(() {
      final user = _authService.currentUser;
      final userName = user?.name ?? 'User';
      final roleName = _getRoleDisplayName(_authService.userRole);
      final isShowSetting = _authService.userRole == "pusat" || _authService.userRole == "branchmanager" || _authService.userRole == "kasir";
      final isShowNotif = _authService.userRole != "kasir";

      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardPadding),
        ),
        child: Row(
          children: [
            if (isShowSetting) ...[
              AppIconButton(
                icon: AppIcons.settings,
                onPressed: () {
                  Get.toNamed(Routes.SETTING);
                },
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            if (isShowNotif) ...[
              AppIconButton(
                icon: AppIcons.notification,
                onPressed: () {
                  // Handle notifications
                },
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            _buildUserAvatar(userName, roleName),
          ],
        ),
      );
    });
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'kasir':
        return 'Kasir';
      case 'gudang':
        return 'Admin Gudang';
      case 'pusat':
        return 'Admin Pusat';
      case 'branchmanager':
        return 'Branch Manager';
      default:
        return 'User';
    }
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AppText(
            'Real-time',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          AppText(
            'Hari ini - Pk 00:00 (GMT+07)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          const Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String userName, String roleName) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: _authService.currentUser?.photoUrl != null && _authService.currentUser!.photoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _authService.currentUser!.photoUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
          const SizedBox(width: AppDimensions.spacing10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: AppText(
                    userName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AppText(
                roleName,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'logout',
            child: AppText.body('Logout'),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'logout':
            _authService.logout();
            break;
        }
      },
    );
  }

// Helper method untuk avatar default
  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          _authService.currentUser?.name?.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Card widget for consistent card styling across app
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? action;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || action != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    AppText(
                      title!,
                      style: AppTextStyles.h3,
                    ),
                  if (action != null) action!,
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

// Dashboard layout with specific structure for dashboards
class DashboardLayout extends StatelessWidget {
  final List<Widget> topCards;
  final List<Widget> middleContent;
  final List<Widget> bottomCards;

  const DashboardLayout({
    super.key,
    required this.topCards,
    required this.middleContent,
    required this.bottomCards,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: List.generate(
            topCards.length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < topCards.length - 1 ? AppDimensions.spacing16 : 0,
                ),
                child: topCards[index],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        ...middleContent,
        const SizedBox(height: AppDimensions.spacing16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            bottomCards.length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < bottomCards.length - 1 ? AppDimensions.spacing16 : 0,
                ),
                child: bottomCards[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
