import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_sizes.dart';

class KDropdown extends StatefulWidget {
  // Core Properties
  final String? labelText;
  final String? hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  // Styling
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? labelColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  // Validation
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool isSearchable;
  final bool isEnabled;

  // Behavior
  final String? searchHintText;
  final String? dialogTitle;
  final bool showClearButton;
  final VoidCallback? onClear;

  // Constraints
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;

  // Custom Items
  final Widget? leading;
  final Widget? trailing;
  final String? placeholder;

  // New: Dialog height ratio (0.0 to 1.0)
  final double dialogHeightRatio;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const KDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.labelColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.validator,
    this.isRequired = false,
    this.isSearchable = false,
    this.isEnabled = true,
    this.searchHintText,
    this.dialogTitle,
    this.showClearButton = false,
    this.onClear,
    this.width,
    this.height,
    this.contentPadding,
    this.leading,
    this.trailing,
    this.placeholder,
    this.dialogHeightRatio = 0.55,
    this.showAddButton = false,
    this.onAddPressed,
  });

  @override
  State<KDropdown> createState() => _KDropdownState();
}

class _KDropdownState extends State<KDropdown>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _selectedValue;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _selectedValue = widget.value;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(KDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      constraints: const BoxConstraints(minHeight: 56),
      child: FormField<String>(
        validator: widget.validator,
        initialValue: _selectedValue,
        builder: (FormFieldState<String> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: widget.isRequired
                  ? '${widget.labelText} *'
                  : widget.labelText,
              labelStyle: TextStyle(
                color: widget.labelColor ?? AppColors.textSecondary,
                fontSize: AppFontSizes.labelLarge,
                fontWeight: FontWeight.w500,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: widget.fontSize ?? AppFontSizes.bodyMedium,
              ),
              prefixIcon: widget.leading ??
                  (widget.prefixIcon != null
                      ? Icon(
                    widget.prefixIcon,
                    color: _getIconColor(),
                  )
                      : null),
              suffixIcon: widget.trailing ?? _buildSuffixIcon(field),
              filled: true,
              fillColor: widget.fillColor ?? Colors.grey.shade50,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
              border: _buildBorder(),
              enabledBorder: _buildBorder(),
              focusedBorder: _buildFocusedBorder(),
              errorBorder: _buildErrorBorder(),
              focusedErrorBorder: _buildFocusedErrorBorder(),
              errorStyle: TextStyle(
                color: AppColors.danger,
                fontSize: AppFontSizes.bodySmall,
              ),
              isDense: true,
            ),
            isEmpty: _selectedValue == null || _selectedValue!.isEmpty,
            child: InkWell(
              onTap: widget.isEnabled
                  ? () => _showDropdownDialog(context, field)
                  : null,
              borderRadius:
              BorderRadius.circular(widget.borderRadius ?? 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedValue ?? widget.placeholder ?? '',
                        style: TextStyle(
                          color: _selectedValue != null
                              ? (widget.textColor ?? AppColors.textPrimary)
                              : Colors.grey.shade400,
                          fontSize:
                          widget.fontSize ?? AppFontSizes.bodyMedium,
                          fontWeight:
                          widget.fontWeight ?? FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    if (_selectedValue != null &&
                        widget.showClearButton)
                      GestureDetector(
                        onTap: () {
                          _clearSelection(field);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // SUFFIX ICON
  // ============================================================================
  Widget _buildSuffixIcon(FormFieldState<String> field) {
    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, color: _getIconColor());
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 3.14159,
          child: Icon(Icons.keyboard_arrow_down_outlined, color: _getIconColor(), size: 28),
        );
      },
    );
  }

  // ============================================================================
  // BORDER BUILDERS
  // ============================================================================
  InputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: BorderSide(
        color: widget.borderColor ?? Colors.grey.shade300,
        width: 1.5,
      ),
    );
  }

  InputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    );
  }

  InputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
    );
  }

  InputBorder _buildFocusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: const BorderSide(color: AppColors.danger, width: 2),
    );
  }

  // ============================================================================
  // ICON COLOR
  // ============================================================================
  Color _getIconColor() {
    if (_isFocused) return AppColors.primary;
    return Colors.grey.shade600;
  }

  // ============================================================================
  // SHOW DROPDOWN DIALOG
  // ============================================================================
  Future<void> _showDropdownDialog(
    BuildContext context,
    FormFieldState<String> field,
  ) async {
    _animationController.forward();

    if (widget.isSearchable) {
      await _showSearchableDialog(context, field);
    } else {
      await _showSimpleDialog(context, field);
    }

    _animationController.reverse();
  }

  // ============================================================================
  // SIMPLE DIALOG (Non-searchable)
  // ============================================================================
  Future<void> _showSimpleDialog(
      BuildContext context,
      FormFieldState<String> field,
      ) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * widget.dialogHeightRatio,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            if (widget.dialogTitle != null || widget.labelText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.dialogTitle ??
                            widget.labelText ??
                            'Select Option',
                        style: const TextStyle(
                          fontSize: AppFontSizes.heading3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (widget.showAddButton)
                      Card(
                        color: AppColors.card,
                        elevation: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onAddPressed?.call();
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add"),
                        ),
                      ),
                  ],
                ),
              ),

            Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = item == _selectedValue;

                  return _buildListItem(
                    context: context,
                    item: item,
                    isSelected: isSelected,
                    field: field,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // SEARCHABLE DIALOG
  // ============================================================================
  Future<void> _showSearchableDialog(
      BuildContext context,
      FormFieldState<String> field,
      ) async {
    _searchController.clear();
    List<String> filteredItems = widget.items;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * widget.dialogHeightRatio,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildSearchBar(setState, filteredItems),
              ),

              // Header
              if (widget.dialogTitle != null || widget.labelText != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.dialogTitle ??
                              widget.labelText ??
                              'Select Option',
                          style: const TextStyle(
                            fontSize: AppFontSizes.heading3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (widget.showAddButton)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onAddPressed?.call();
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add"),
                        ),
                    ],
                  ),
                ),

              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),

              // List
              Expanded(
                child: filteredItems.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isSelected = item == _selectedValue;

                    return _buildListItem(
                      context: context,
                      item: item,
                      isSelected: isSelected,
                      field: field,
                    );
                  },
                ),
              ),

              // Cancel Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // SEARCH BAR
  // ============================================================================
  Widget _buildSearchBar(StateSetter setState, List<String> filteredItems) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.searchHintText ?? 'Search...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      filteredItems = widget.items;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            filteredItems = widget.items
                .where(
                  (item) => item.toLowerCase().contains(value.toLowerCase()),
                )
                .toList();
          });
        },
      ),
    );
  }

  // ============================================================================
  // LIST ITEM
  // ============================================================================
  Widget _buildListItem({
    required BuildContext context,
    required String item,
    required bool isSelected,
    required FormFieldState<String> field,
  }) {
    return InkWell(
      onTap: () {
        _selectItem(item, field);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // EMPTY STATE
  // ============================================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: AppFontSizes.bodyLarge,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SELECT ITEM
  // ============================================================================
  void _selectItem(String item, FormFieldState<String> field) {
    setState(() {
      _selectedValue = item;
    });
    field.didChange(item);
    if (widget.onChanged != null) {
      widget.onChanged!(item);
    }
  }

  // ============================================================================
  // CLEAR SELECTION
  // ============================================================================
  void _clearSelection(FormFieldState<String> field) {
    setState(() {
      _selectedValue = null;
    });
    field.didChange(null);
    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }
}
