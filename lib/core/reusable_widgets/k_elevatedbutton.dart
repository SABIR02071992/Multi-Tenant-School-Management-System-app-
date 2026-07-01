import 'package:flutter/material.dart';

class KElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;              // Optional: Icon dynamically select karne ke liye
  final Color backgroundColor;       // Optional: Default theme wrap override properties
  final Color foregroundColor;       // Optional: Label text context layout colors
  final double verticalPadding;      // Custom height control parameters
  final double horizontalPadding;    // Custom width dynamic distribution
  final double borderRadius;         // Shape structure corner radius layout
  final bool isLoading;              // Async loading spinner integration check

  const KElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFF1E3A8A), // Default Primary Navy Blue Color
    this.foregroundColor = Colors.white,
    this.verticalPadding = 16.0,
    this.horizontalPadding = 20.0,
    this.borderRadius = 8.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Shared common visual parameters initialization setup
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    // 1. Loading Trigger State Flow Checking UI
    if (isLoading) {
      return ElevatedButton(
        onPressed: null, // Loading time pr dynamic action locks layout
        style: buttonStyle,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: foregroundColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // 2. Icon Button Variant Layout (If icon parameter is present)
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: buttonStyle,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 3. Standard Base Variant Layout Execution Flow
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
