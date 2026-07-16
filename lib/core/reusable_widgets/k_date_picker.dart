import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class KDatePicker extends StatelessWidget {
  // ============================================================================
  // PROPERTIES
  // ============================================================================
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final String? errorText;
  final bool isRequired;
  final String dateFormat;
  final Color? primaryColor;
  final Color? borderColor;
  final IconData? prefixIcon;

  const KDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = "Select Date",
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateSelected,
    this.errorText,
    this.isRequired = false,
    this.dateFormat = 'dd-MM-yyyy',
    this.primaryColor,
    this.borderColor,
    this.prefixIcon,
  });

  // ============================================================================
  // BUILD
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? AppColors.primary;
    final border = borderColor ?? AppColors.border;

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: AppColors.textSecondary,
          size: 20,
        )
            : null,
        suffixIcon: Icon(
          Icons.calendar_today,
          color: primary,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontSize: 14,
        ),
        errorStyle: const TextStyle(
          color: AppColors.danger,
          fontSize: 12,
        ),
      ),
      onTap: () => _showDatePicker(context), // ✅ Pass context
      validator: _validateDate,
    );
  }

  // ============================================================================
  // DATE PICKER
  // ============================================================================
  Future<void> _showDatePicker(BuildContext context) async {
    try {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: _getInitialDate(),
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
        builder: (context, child) {
          final primary = primaryColor ?? AppColors.primary;
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.black,
                surface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                ),
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        final formattedDate = DateFormat(dateFormat).format(pickedDate);
        controller.text = formattedDate;
        onDateSelected?.call(pickedDate);
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Error showing date picker: $e');
    }
  }

  // ============================================================================
  // HELPERS
  // ============================================================================
  DateTime _getInitialDate() {
    if (initialDate != null) return initialDate!;

    // Try to parse from controller text
    if (controller.text.isNotEmpty) {
      try {
        final parsed = DateFormat(dateFormat).parse(controller.text);
        return parsed;
      } catch (_) {
        // If parsing fails, return current date
      }
    }

    // Fallback to current date
    return DateTime.now();
  }

  String? _validateDate(String? value) {
    if (!isRequired) return null;
    if (value == null || value.isEmpty) {
      return "Please select $labelText";
    }
    return null;
  }
}

// ============================================================================
// EXTENSION FOR EASY USAGE
// ============================================================================
extension KDatePickerExtension on DateTime {
  String toFormattedDate({String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).format(this);
  }
}