import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/bottom_nav_visible_provider.dart';



class KHideBottomNavOnScroll extends ConsumerWidget {
  final Widget child;

  const KHideBottomNavOnScroll({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.reverse) {
          ref.read(bottomNavVisibleProvider.notifier).state = false;
        } else if (notification.direction == ScrollDirection.forward) {
          ref.read(bottomNavVisibleProvider.notifier).state = true;
        }

        return false;
      },
      child: child,
    );
  }
}