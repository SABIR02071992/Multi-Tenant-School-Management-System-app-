import 'package:flutter/material.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';

class KDropdown extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final IconData? prefixIcon;
  final IconData suffixIcon;
  final String? Function(String?)? validator;

  const KDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon = Icons.keyboard_arrow_down_rounded,
    this.validator,
  });

  @override
  State<KDropdown> createState() => _KDropdownState();
}

class _KDropdownState extends State<KDropdown> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    // 🟢 Aapke AppColors ke mutabik dynamic theme configuration
    const Color activeColor = AppColors.textPrimary;       // Focused State (Dark Premium Navy)
    const Color normalColor = AppColors.textSecondary;     // Normal State (Standard Text Grey)
    const Color hintColor = AppColors.textHint;           // Placeholder / Hint

    return DropdownButtonFormField<String>(
      value: widget.value,
      focusNode: _focusNode,

      // 🟢 Dropdown items text style ko update kiya premium navy look ke liye
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),

      // 🟢 Suffix arrow ka color focus hone par hi active/highlight hoga
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          widget.suffixIcon,
          color: isFocused ? activeColor : normalColor,
        ),
      ),

      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: isFocused ? activeColor : normalColor),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: hintColor),

        // 🟢 Prefix Icon color updates based on click status
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: isFocused ? activeColor : normalColor)
            : null,

        // 🟢 Borders mapping according to AppColors guidelines
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5), // Clean premium border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: activeColor, width: 2), // Focus indicator border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.redWarring, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.redWarring, width: 2),
        ),
      ),
      items: widget.items.map(
            (item) => DropdownMenuItem<String>(
          value: item,
          // 🟢 Dropdown menu ke andar ka text style consistent kiya
          child: Text(
            item,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ).toList(),
      onChanged: widget.onChanged,
      validator: widget.validator ?? (value) {
        if (value == null || value.isEmpty || value == "---Select Role---") {
          return "Please select a role";
        }
        return null;
      },
    );
  }
}
