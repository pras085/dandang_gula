import 'package:flutter/material.dart';
import '../config/constant/app_fonts.dart';
import '../config/theme/app_colors.dart';

/// Utility class to manage font styles
class FontUtils {
  // Helper method untuk membuat TextStyle dengan font tertentu
  static TextStyle getFont({
    required AppFont font,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: font.fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      fontStyle: fontStyle,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}

/// Utility class to manage asset paths
class AppAssets {
  // Base paths
  static const String _basePath = 'assets';
  static const String _imagesPath = '$_basePath/images';
  static const String _iconsPath = '$_basePath/icons';
  static const String _fontsPath = '$_basePath/fonts';

  // Icon paths by category
}

/// Icon paths by category
class AppIcons {
  // Navigation icons
  static const String arrowDown = '${AppAssets._iconsPath}/arrow-down.svg';
  static const String arrowUp = '${AppAssets._iconsPath}/arrow-up.svg';
  static const String arrowLeft = '${AppAssets._iconsPath}/arrow-left.svg';
  static const String arrowRight = '${AppAssets._iconsPath}/arrow-right.svg';
  static const String arrowDownLeft = '${AppAssets._iconsPath}/arrow-down-left.svg';
  static const String arrowDownRight = '${AppAssets._iconsPath}/arrow-down-right.svg';
  static const String arrowCounterClockwise = '${AppAssets._iconsPath}/arrow-counter-clockwise.svg';

  // Action icons
  static const String add = '${AppAssets._iconsPath}/add.svg';
  static const String edit = '${AppAssets._iconsPath}/edit.svg';
  static const String delete = '${AppAssets._iconsPath}/delete.svg';
  static const String save = '${AppAssets._iconsPath}/save.svg';
  static const String close = '${AppAssets._iconsPath}/close.svg';
  static const String download = '${AppAssets._iconsPath}/download.svg';
  static const String settings = '${AppAssets._iconsPath}/settings.svg';

  // UI element icons
  static const String checkmark = '${AppAssets._iconsPath}/checkmark.svg';
  static const String caretDown = '${AppAssets._iconsPath}/caret-down.svg';
  static const String caretUp = '${AppAssets._iconsPath}/caret-up.svg';
  static const String caretLeft = '${AppAssets._iconsPath}/caret-left.svg';
  static const String caretRight = '${AppAssets._iconsPath}/caret-right.svg';
  static const String caretSort = '${AppAssets._iconsPath}/caret-sort.svg';

  // Feature icons
  static const String dashboard = '${AppAssets._iconsPath}/dashboard.svg';
  static const String home = '${AppAssets._iconsPath}/home.svg';
  static const String login = '${AppAssets._iconsPath}/login.svg';
  static const String logout = '${AppAssets._iconsPath}/logout.svg';
  static const String appIcon = '${AppAssets._iconsPath}/app-icon.png';
  static const String userAvatar = '${AppAssets._iconsPath}/user-avatar.svg';
  static const String userAccess = '${AppAssets._iconsPath}/user-access.svg';
  static const String customerService = '${AppAssets._iconsPath}/customer-service.svg';

  // Module specific icons
  static const String orderDetails = '${AppAssets._iconsPath}/order-details.svg';
  static const String restaurant = '${AppAssets._iconsPath}/restaurant.svg';
  static const String shoppingBag = '${AppAssets._iconsPath}/shopping-bag.svg';
  static const String shoppingCatalog = '${AppAssets._iconsPath}/shopping-catalog.svg';
  static const String purchase = '${AppAssets._iconsPath}/purchase.svg';
  static const String reportData = '${AppAssets._iconsPath}/report-data.svg';
  static const String printer = '${AppAssets._iconsPath}/printer.svg';
  static const String percentage = '${AppAssets._iconsPath}/percentage.svg';
  static const String notification = '${AppAssets._iconsPath}/notification-new.svg';
  static const String bottlesContainer = '${AppAssets._iconsPath}/bottles-container.svg';

  // View related
  static const String viewFilled = '${AppAssets._iconsPath}/view-filled.svg';
  static const String viewOffFilled = '${AppAssets._iconsPath}/view-off-filled.svg';
  static const String splitScreen = '${AppAssets._iconsPath}/split-screen.svg';
  static const String overflowMenuHorizontal = '${AppAssets._iconsPath}/overflow-menu-horizontal.svg';

  // Business specific
  static const String ibmGcm = '${AppAssets._iconsPath}/ibm-gcm.svg';
  static const String calendarHeatMap = '${AppAssets._iconsPath}/calendar-heat-map.svg';
  static const String camera = '${AppAssets._iconsPath}/camera.svg';
  static const String trashCan = '${AppAssets._iconsPath}/trash-can.svg';
  static const String wheat = '${AppAssets._iconsPath}/wheat.svg';
  static const String noodleBowl = '${AppAssets._iconsPath}/noodle-bowl.svg';

  // Logo
  static const String logoDandangGula = '${AppAssets._iconsPath}/logo-dandang-gula.png';
}

/// Images paths
class Images {
  static const String logo = '${AppAssets._imagesPath}/logo-.png';
  static const String background = '${AppAssets._imagesPath}/background.png';
  static const String placeholder = '${AppAssets._imagesPath}/placeholder.png';

  // Add more image paths as needed
}

/// Font paths if needed
class Fonts {
  static const String roboto = '${AppAssets._fontsPath}/Roboto-Regular.ttf';
}

/// Extension to make asset path generation more flexible
extension AssetPathExtension on String {
  String get toIconPath => 'assets/icons/$this';
  String get toImagePath => 'assets/images/$this';
  String get toFontPath => 'assets/fonts/$this';

  String withIconExtension(String extension) => 'assets/icons/$this.$extension';
  String withImageExtension(String extension) => 'assets/images/$this.$extension';
}
