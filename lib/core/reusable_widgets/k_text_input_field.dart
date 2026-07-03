import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';

class KTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isPassword;
  final AutovalidateMode autoValidateMode;

  const KTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.isPassword = false,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  late bool _isObscured;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
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
    const Color activeColor = AppColors.textPrimary;
    const Color normalColor = AppColors.textSecondary;
    const Color hintColor = AppColors.textHint;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      obscureText: _isObscured,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: isFocused ? activeColor : normalColor),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: hintColor),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: isFocused ? activeColor : normalColor,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isFocused ? activeColor : normalColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1.5,
          ), // Clean subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: activeColor,
            width: 2,
          ), // Highlighting border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.redWarring,
            width: 1.5,
          ), // Error state border
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.redWarring, width: 2),
        ),
      ),
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "${widget.labelText} is required";
            }
            return null;
          },
    );
  }
}
