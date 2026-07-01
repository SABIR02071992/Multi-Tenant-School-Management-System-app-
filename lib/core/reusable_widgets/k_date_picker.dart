import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  const KDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = "Select Date",
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Keyboard open hone se rokega
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
      ),
      onTap: () async {
        // Date picker dialog open hoga
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000), // Default past limit
          lastDate: lastDate ?? DateTime(2101),  // Default future limit
          builder: (context, child) {
            // Theme match karne ke liye custom styling
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1E3A8A), // Header background color
                  onPrimary: Colors.white, // Header text color
                  onSurface: Colors.black, // Body text color
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          // Date ko formatted string mein convert karke controller ko dena
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.text = formattedDate;

          // Agar baahar koi extra logic chalani ho (jaise API call)
          if (onDateSelected != null) {
            onDateSelected!(pickedDate);
          }
        }
      },
    );
  }
}
