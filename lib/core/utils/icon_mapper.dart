import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String icon) {
    switch (icon) {
      case "school":
        return Icons.school;

      case "person":
        return Icons.person;

      case "groups":
        return Icons.groups;

      case "admin_panel_settings":
        return Icons.admin_panel_settings;

      case "fact_check":
        return Icons.fact_check;

      case "campaign":
        return Icons.campaign;

      case "person_add":
        return Icons.person_add;

      case "logout":
        return Icons.logout;

      case "lock":
        return Icons.lock_open;

      case "business":
        return Icons.school;

      default:
        return Icons.widgets;
    }
  }
}