import 'package:flutter/material.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';

class KSearchableDropdownDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final String Function(T) itemValueBuilder;
  final String? initialValue;
  final String? hintText; // 🟢 1. Yaha par hintText declare kiya taaki niche error na aaye

  const KSearchableDropdownDialog({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabelBuilder,
    required this.itemValueBuilder,
    this.initialValue,
    this.hintText, // 🟢 2. Constructor me add kiya
  });

  static Future<String?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required String Function(T) itemValueBuilder,
    String? initialValue,
    String? hintText, // 🟢 3. Static show method me bhi add kiya pass karne ke liye
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => KSearchableDropdownDialog<T>(
        title: title,
        items: items,
        itemLabelBuilder: itemLabelBuilder,
        itemValueBuilder: itemValueBuilder,
        initialValue: initialValue,
        hintText: hintText, // 🟢 4. State ko pass kiya
      ),
    );
  }

  @override
  State<KSearchableDropdownDialog<T>> createState() => _SearchableDropdownDialogState<T>();
}

class _SearchableDropdownDialogState<T> extends State<KSearchableDropdownDialog<T>> {
  String? _selectedValue;
  String _searchQuery = "";
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? (widget.items.isNotEmpty ? widget.itemValueBuilder(widget.items.first) : null);

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _searchFocusNode.hasFocus;
    const Color activeColor = AppColors.textPrimary;
    const Color normalColor = AppColors.textSecondary;
    const Color hintColor = AppColors.textHint;

    final filteredList = widget.items.where((item) {
      final label = widget.itemLabelBuilder(item).toLowerCase();
      return label.contains(_searchQuery.toLowerCase());
    }).toList();

    return AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: _searchFocusNode,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Search...',
                labelStyle: TextStyle(color: isFocused ? activeColor : normalColor),
                hintText: widget.hintText ?? 'Type to filter...', // 🟢 Ab yeh red show nahi karega!
                hintStyle: const TextStyle(color: hintColor),
                prefixIcon: Icon(Icons.search, color: isFocused ? activeColor : normalColor),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: activeColor, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            filteredList.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("No items found", style: TextStyle(color: AppColors.textSecondary)),
            )
                : Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final itemValue = widget.itemValueBuilder(item);
                    final itemLabel = widget.itemLabelBuilder(item);
                    final isSelected = _selectedValue == itemValue;

                    return ListTile(
                      title: Text(
                        itemLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppColors.primary.withOpacity(0.08),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.success)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedValue = itemValue;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(context, _selectedValue);
          },
          child: const Text("Proceed", style: TextStyle(color: AppColors.textLight)),
        ),
      ],
    );
  }
}
