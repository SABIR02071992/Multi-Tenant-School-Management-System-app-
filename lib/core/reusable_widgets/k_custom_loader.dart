import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KCustomLoader extends StatelessWidget {
  final String? message;
  final double size;

  const KCustomLoader({
    super.key,
    this.message,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation(
                      AppColors.primary,
                    ),
                    backgroundColor:
                    AppColors.primary.withOpacity(.15),
                  ),
                ),
                Icon(
                  Icons.school_rounded,
                  color: AppColors.primary,
                  size: size * .42,
                ),
              ],
            ),
          ),

          if (message != null) ...[
            const SizedBox(height: 18),
            Text(
              message!,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}