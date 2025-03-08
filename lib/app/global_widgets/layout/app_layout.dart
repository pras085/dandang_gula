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
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showDatePicker;
  final VoidCallback? onMenuPressed;

  // Get auth service for user role
  final AuthService _authService = Get.find<AuthService>();

  AppLayout({
    super.key,
    required this.body,
    this.title = '',
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.showBackButton = false,
    this.showDatePicker = true,
    this.onMenuPressed,
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
          body: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: Column(
              children: [
                _buildAppBarContent(),
                Expanded(child: body),
              ],
            ),
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardPadding),
      ),
      child: Row(
        children: [
          _buildLogo(),
          const SizedBox(width: AppDimensions.spacing16),
          _buildNavigationItems(),
          const Spacer(),
          if (actions != null) ...actions!,
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      AppIcons.appIcon,
      height: 50,
      width: 50,
    );
  }

  Widget _buildNavigationItems() {
    // Different menu items based on user role
    return Row(
      children: _getNavigationItemsByRole(),
    );
  }

  List<Widget> _getNavigationItemsByRole() {
    final navItems = <Widget>[];
    final currentRole = _getUserRoleEnum();

    // Add Dashboard button for all roles
    navItems.add(
      _buildNavItem(
        'Dashboard',
        AppIcons.dashboard,
        true,
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
            false,
            () {
              Get.toNamed(Routes.BRANCH_MANAGEMENT);
            },
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            false,
            () {
              Get.toNamed(Routes.USER_MANAGEMENT);
            },
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            false,
            () {
              Get.toNamed(Routes.REPORTS);
            },
          ),
        ]);
        break;

      case UserRole.kasir:
        navItems.addAll([
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            false,
            () {
              Get.toNamed(Routes.ORDERS);
            },
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            false,
            () {
              Get.toNamed(Routes.REPORTS);
            },
          ),
          _buildNavItem(
            'Presensi',
            AppIcons.userAccess,
            false,
            () {
              Get.toNamed(Routes.ATTENDANCE);
            },
          ),
        ]);
        break;

      case UserRole.gudang:
        navItems.addAll([
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            false,
            () {
              Get.toNamed(Routes.STOCK_IN);
            },
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            false,
            () {
              Get.toNamed(Routes.REPORTS);
            },
          ),
        ]);
        break;

      case UserRole.pusat:
        navItems.addAll([
          _buildNavItem(
            'Manajemen Cabang',
            AppIcons.orderDetails,
            false,
            () {
              Get.toNamed(Routes.BRANCH_MANAGEMENT);
            },
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            false,
            () {
              Get.toNamed(Routes.USER_MANAGEMENT);
            },
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            false,
            () {
              Get.toNamed(Routes.REPORTS);
            },
          ),
        ]);
        break;

      case UserRole.branchmanager:
        navItems.addAll([
          _buildNavItem(
            'Management Menu',
            AppIcons.restaurant,
            false,
            () {
              Get.toNamed(Routes.MENU_MANAGEMENT);
            },
          ),
          _buildNavItem(
            'Stok Bahan',
            AppIcons.wheat,
            false,
            () {
              Get.toNamed(Routes.INVENTORY);
            },
          ),
          _buildNavItem(
            'Pesanan',
            AppIcons.orderDetails,
            false,
            () {
              Get.toNamed(Routes.ORDERS);
            },
          ),
          _buildNavItem(
            'Laporan',
            AppIcons.reportData,
            false,
            () {
              Get.toNamed(Routes.REPORTS);
            },
          ),
          _buildNavItem(
            'Management User',
            AppIcons.userAccess,
            false,
            () {
              Get.toNamed(Routes.USER_MANAGEMENT);
            },
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
        child: Container(
          width: isActive ? 125 : 180,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 1,
            ),
            boxShadow: isActive
                ? [
                    const BoxShadow(
                      color: AppColors.white,
                      spreadRadius: -2,
                      blurRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isActive ? const Color(0xFFE2B472) : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.buttonSmall.copyWith(
                  fontFamily: 'IBMPlexSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isActive ? const Color(0xFFE2B472) : AppColors.textPrimary,
                ),
              ),
            ],
          ),
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

      return Row(
        children: [
          if (showDatePicker) _buildDatePicker(),
          const SizedBox(width: AppDimensions.spacing16),
          AppIconButton(
            icon: Icons.notifications_none,
            onPressed: () {
              // Handle notifications
            },
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          _buildUserAvatar(userName, roleName),
        ],
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
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
            image: const DecorationImage(
              image: NetworkImage(''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacing8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              userName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppText(
              roleName,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(width: AppDimensions.spacing8),
        const Icon(
          Icons.arrow_drop_down,
          color: AppColors.textPrimary,
        ),
      ],
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

// Example usage:
/*
class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      userRole: UserRole.admin,
      body: DashboardLayout(
        topCards: [
          AppCard(
            title: 'Total Income',
            child: // income widget
          ),
          AppCard(
            title: 'Net Profit',
            child: // profit widget
          ),
        ],
        middleContent: [
          AppCard(
            title: 'Total Income',
            child: // chart widget
          ),
        ],
        bottomCards: [
          AppCard(
            title: 'Sales Performance',
            child: // performance widget
          ),
          AppCard(
            title: 'Sales Performance',
            child: // performance widget
          ),
          AppCard(
            title: 'Sales Performance',
            child: // performance widget
          ),
        ],
      ),
    );
  }
}
*/