import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KTopSnackBar {
  KTopSnackBar._();

  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  //==================== Success ====================//

  static void success({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      backgroundColor:  AppColors.green,
      icon: Icons.check_circle_rounded,
    );
  }

  //==================== Error ====================//

  static void error({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColors.red,
      icon: Icons.error_rounded,
    );
  }

  //==================== Warning ====================//

  static void warning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    );
  }

  //==================== Info ====================//

  static void info({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _show(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_rounded,
    );
  }

  //==================== Main ====================//

  static void _show({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    _remove();

    final overlay = Overlay.of(context);

    _currentEntry = OverlayEntry(
      builder: (_) {
        return _TopSnackBarWidget(
          title: title,
          message: message,
          color: backgroundColor,
          icon: icon,
          onClose: _remove,
        );
      },
    );

    overlay.insert(_currentEntry!);

    _timer = Timer(
      const Duration(seconds: 3),
          () => _remove(),
    );
  }

  static void _remove() {
    _timer?.cancel();
    _timer = null;

    _currentEntry?.remove();
    _currentEntry = null;
  }
}
class _TopSnackBarWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onClose;

  const _TopSnackBarWidget({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.onClose,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: top + 12,
              left: 16,
              right: 16,
            ),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: widget.color,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _close,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                            Colors.white.withOpacity(.18),
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  widget.message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            splashRadius: 18,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: _close,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}