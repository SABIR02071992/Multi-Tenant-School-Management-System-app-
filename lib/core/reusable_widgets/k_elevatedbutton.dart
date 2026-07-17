import 'package:flutter/material.dart';

class KElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;
  final double height;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;
  final bool isLoading;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  const KElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFF1E3A8A),
    this.foregroundColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.verticalPadding = 16,
    this.horizontalPadding = 20,
    this.borderRadius = 8,
    this.isLoading = false,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,

      disabledBackgroundColor:
      disabledBackgroundColor ?? backgroundColor.withOpacity(0.5),

      disabledForegroundColor:
      disabledForegroundColor ?? foregroundColor.withOpacity(0.7),

      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    Widget child;

    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: foregroundColor,
          strokeWidth: 2,
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      child = Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}