import 'package:flutter/material.dart';
import 'package:vidya_setu/core/theme/app_font_sizes.dart';

import '../theme/app_colors.dart';

class KWelcomeCard extends StatelessWidget {
  final String name;
  final String role;
  final String? email;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const KWelcomeCard({
    super.key,
    required this.name,
    required this.role,
    this.email,
    this.subtitle,
    this.icon = Icons.account_circle_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.blue,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [

            Positioned(
              right: -25,
              top: -25,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 20,
              bottom: -20,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(.08),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [

                  Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.card,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppFontSizes.heading3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Welcome Back 👋",
                          style: TextStyle(
                            color: AppColors.card,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [

                            _Chip(
                              icon: Icons.badge,
                              text: role,
                            ),

                            if (email != null)
                              _Chip(
                                icon: Icons.email_outlined,
                                text: email!,
                              ),
                          ],
                        ),

                        if (subtitle != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: AppColors.card,
                              fontSize: 13,
                            ),
                          ),
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}