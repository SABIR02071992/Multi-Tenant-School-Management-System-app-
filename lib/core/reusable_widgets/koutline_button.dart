import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class KOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  final Color borderColor;
  final Color foregroundColor;
  final Color backgroundColor;

  /// Button Size
  final double? width;
  final double height;

  final double borderRadius;
  final double borderWidth;

  final bool isLoading;

  const KOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.borderColor = AppColors.primary,
    this.foregroundColor = AppColors.primary,
    this.backgroundColor = Colors.transparent,

    /// null = wrap content
    /// double.infinity = full width
    this.width,

    this.height = 38,

    this.borderRadius = 20,
    this.borderWidth = 1.5,

    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive values
    final double fontSize = (height * 0.32).clamp(12.0, 16.0);
    final double iconSize = (height * 0.42).clamp(16.0, 22.0);
    final double verticalPadding = (height * 0.10).clamp(2.0, 8.0);
    final double horizontalPadding = (height * 0.45).clamp(12.0, 24.0);

    final ButtonStyle style = OutlinedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      minimumSize: Size(0, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget button;

    if (isLoading) {
      button = OutlinedButton(
        onPressed: null,
        style: style,
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: foregroundColor,
          ),
        ),
      );
    } else if (icon != null) {
      button = OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(
          icon,
          size: iconSize,
        ),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary
          ),
        ),
      );
    } else {
      button = OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Wrap content
    if (width == null) {
      return button;
    }

    // Fixed / Full width
    return SizedBox(
      width: width,
      child: button,
    );
  }
}