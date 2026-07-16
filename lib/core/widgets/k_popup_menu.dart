import 'package:flutter/material.dart';

class KPopupMenu extends StatelessWidget {
  final void Function(String value)? onSelected;

  const KPopupMenu({
    super.key,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: "edit",
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 10),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 10),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
  }
}