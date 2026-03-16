import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'splash_painter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), // Original animation took roughly 2.4s
    );

    _controller.forward();

    // Redirection delay: gives time to admire the finished animation
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        context.go(RouteConstants.home); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: SplashPainter(
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}
