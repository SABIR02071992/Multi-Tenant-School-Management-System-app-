import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'k_loader.dart';

class KButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String buttonText;

  const KButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: isLoading
            ? const SizedBox(
          key: ValueKey('loader'),
          height: 24,
          child: KLoader(
            color: AppColors.white,
            size: 8,
          ),
        )
            : Text(
          buttonText,
          key: const ValueKey('text'),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}