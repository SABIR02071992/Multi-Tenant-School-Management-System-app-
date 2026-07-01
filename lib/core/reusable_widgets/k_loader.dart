import 'package:flutter/material.dart';

class KLoader extends StatefulWidget {
  final Color color;
  final double size;

  const KLoader({
    super.key,
    this.color = const Color(0xFF0F172A), // Aapka corporate dark theme color
    this.size = 10.0, // Dot ka size
  });

  @override
  State<KLoader> createState() => _KLoaderState();
}

class _KLoaderState extends State<KLoader> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    });

    for (int i = 0; i < 3; i++) {
      _animations.add(Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
      ));

      // Har dot ko thode delay ke baad start karenge taaki wave effect bane
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(1.0 - (index * 0.2)), // Beautiful opacity gradient
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
