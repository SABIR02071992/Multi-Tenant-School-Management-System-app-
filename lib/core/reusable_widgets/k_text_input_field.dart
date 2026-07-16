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
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizontal;
  final bool readOnly;
  final bool enabled;
  final bool showCounter;
  final VoidCallback? onTap;

  // New: Bottom counter features
  final bool showCharacterCount;
  final bool showWordCount;
  final String? counterText;
  final TextStyle? counterStyle;
  final Color? counterColor;

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
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.contentPaddingVertical,
    this.contentPaddingHorizontal,
    this.readOnly = false,
    this.enabled = true,
    this.showCounter = false,
    this.onTap,
    this.showCharacterCount = false,
    this.showWordCount = false,
    this.counterText,
    this.counterStyle,
    this.counterColor,
  });

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  late bool _isObscured;
  final FocusNode _focusNode = FocusNode();
  int _characterCount = 0;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(_updateCounts);
    _updateCounts();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_updateCounts);
    super.dispose();
  }

  void _updateCounts() {
    setState(() {
      final text = widget.controller.text;
      _characterCount = text.length;
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;
    const Color activeColor = AppColors.textPrimary;
    const Color normalColor = AppColors.textSecondary;
    const Color hintColor = AppColors.textHint;

    // Check if the textfield is multiline
    final bool isMultiLine = (widget.maxLines == null || widget.maxLines! > 1);

    // Check if we should show counter
    final bool showCounter = widget.showCounter ||
        widget.showCharacterCount ||
        widget.showWordCount ||
        widget.counterText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main TextField
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          autovalidateMode: widget.autoValidateMode,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTap: widget.onTap,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            // FIX: Label alignment - removed alignLabelWithHint for better positioning
            labelStyle: TextStyle(
              color: isFocused ? activeColor : normalColor,
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: hintColor,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.contentPaddingVertical ?? 16,
              horizontal: widget.contentPaddingHorizontal ?? 16,
            ),
            // FIX: Counter text - show only if explicitly enabled
            counterText: "",
            // FIX: Prefix icon alignment for multiline
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: EdgeInsets.only(
                bottom: isMultiLine ? 40.0 : 0.0,
                right: 8.0,
              ),
              child: Icon(
                widget.prefixIcon,
                color: isFocused ? activeColor : normalColor,
                size: 24,
              ),
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
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: activeColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.redWarring,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.redWarring,
                width: 2,
              ),
            ),
            // FIX: Floating label behavior
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          validator: widget.validator ??
                  (value) {
                if (value == null || value.trim().isEmpty) {
                  return "${widget.labelText} is required";
                }
                return null;
              },
        ),

        // Bottom Counter Section
        if (showCounter)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Custom text
                Expanded(
                  child: Text(
                    widget.counterText ?? '',
                    style: widget.counterStyle ?? TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Right side - Counters
                Row(
                  children: [
                    if (widget.showWordCount) _buildCounterItem(
                      icon: Icons.text_fields,
                      count: _wordCount,
                      label: 'words',
                    ),
                    if (widget.showWordCount && widget.showCharacterCount)
                      const SizedBox(width: 12),
                    if (widget.showCharacterCount) _buildCounterItem(
                      icon: Icons.format_size,
                      count: _characterCount,
                      label: widget.maxLength != null ? '/ ${widget.maxLength}' : 'chars',
                      isWarning: widget.maxLength != null && _characterCount > widget.maxLength! * 0.85,
                      isError: widget.maxLength != null && _characterCount >= widget.maxLength!,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ============================================================================
  // COUNTER ITEM
  // ============================================================================
  Widget _buildCounterItem({
    required IconData icon,
    required int count,
    required String label,
    bool isWarning = false,
    bool isError = false,
  }) {
    Color color = widget.counterColor ?? Colors.grey.shade500;
    if (isError) color = AppColors.redWarring;
    else if (isWarning) color = Colors.orange;

    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isError ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}