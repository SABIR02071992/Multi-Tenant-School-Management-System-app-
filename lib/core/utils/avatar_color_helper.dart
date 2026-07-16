import 'dart:ui';

import '../theme/app_colors.dart';

class AvatarColorHelper {
  AvatarColorHelper._();

  static Color background(String key) {
    return AppColors
        .backgrounds[key.hashCode.abs() % AppColors.backgrounds.length];
  }

  static Color foreground(String key) {
    return AppColors
        .foregrounds[key.hashCode.abs() % AppColors.foregrounds.length];
  }
}