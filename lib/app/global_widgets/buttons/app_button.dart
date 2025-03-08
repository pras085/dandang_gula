import 'package:flutter/material.dart';
import '../../config/constant/app_fonts.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../core/utils.dart';

enum ButtonSize { small, medium, large }

enum ButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.white,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _buildContent(),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _buildContent(),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _buildContent(),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            padding: _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _buildContent(),
        );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: AppColors.white,
          strokeWidth: 3,
        ),
      );
    }

    if (prefixIcon == null && suffixIcon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _getHeight()),
          const SizedBox(width: AppDimensions.spacing8),
        ],
        Text(label),
        if (suffixIcon != null) ...[
          const SizedBox(width: AppDimensions.spacing8),
          Icon(suffixIcon, size: _getHeight()),
        ],
      ],
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case ButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case ButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing10,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing32,
          vertical: AppDimensions.spacing12,
        );
    }
  }

  TextStyle _getTextStyle() {
    AppFont font = AppFont.roboto; // Default font
    double fontSize;
    FontWeight fontWeight = FontWeight.bold;

    switch (size) {
      case ButtonSize.small:
        fontSize = 14;
        font = AppFont.inter;
        break;
      case ButtonSize.medium:
        fontSize = 15;
        font = AppFont.roboto;
        break;
      case ButtonSize.large:
        fontSize = 16;
        font = AppFont.inter;
        break;
    }

    return FontUtils.getFont(
      font: font,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _getTextColor(),
    );
  }

  Color _getTextColor() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return AppColors.white;
      case ButtonVariant.outline:
        return AppColors.primary;
      case ButtonVariant.text:
        return AppColors.accent;
    }
  }
}
