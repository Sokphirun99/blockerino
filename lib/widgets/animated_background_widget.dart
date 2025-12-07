import 'dart:math';
import 'package:flutter/material.dart';

/// Animated background with floating particles for atmosphere
class AnimatedBackgroundWidget extends StatefulWidget {
  const AnimatedBackgroundWidget({super.key});

  @override
  State<AnimatedBackgroundWidget> createState() => _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_BackgroundParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Create background particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_BackgroundParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.3 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _BackgroundParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  _BackgroundParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _BackgroundPainter extends CustomPainter {
  final List<_BackgroundParticle> particles;
  final double animationValue;

  _BackgroundPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      particle.y = (particle.y + particle.speed * 0.01) % 1.0;
      
      final paint = Paint()
        ..color = Colors.purple.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw particle with glow effect
      canvas.drawCircle(position, particle.size * 2, paint..color = paint.color.withOpacity(particle.opacity * 0.3));
      canvas.drawCircle(position, particle.size, paint..color = paint.color.withOpacity(particle.opacity));
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => true;
}
