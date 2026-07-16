import 'package:flutter/material.dart';
import 'k_hide_bottom_nav_on_scroll.dart';

class KScrollablePage extends StatelessWidget {
  final Widget child;

  const KScrollablePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return KHideBottomNavOnScroll(
      child: child,
    );
  }
}