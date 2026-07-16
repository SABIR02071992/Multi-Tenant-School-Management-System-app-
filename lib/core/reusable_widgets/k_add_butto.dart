import 'package:flutter/material.dart';

class KAddButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const KAddButton({
    super.key,
    required this.text,
    this.icon = Icons.add,
    this.onTap,
    this.color = Colors.blue,
    this.backgroundColor = const Color(0xFFEFF6FF),
    this.borderColor = const Color(0xFFBFDBFE),
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}