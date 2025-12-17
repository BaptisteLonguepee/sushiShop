import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constant/color.dart';

/// Widget de décoration avec motifs japonais
class JapanesePattern extends StatelessWidget {
  final double opacity;
  final Color color;

  const JapanesePattern({
    super.key,
    this.opacity = 0.05,
    this.color = AppColor.gold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JapanesePatternPainter(color: color.withValues(alpha: opacity)),
      child: Container(),
    );
  }
}

class _JapanesePatternPainter extends CustomPainter {
  final Color color;

  _JapanesePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Motif de vagues japonaises (seigaiha)
    final waveHeight = 30.0;
    final waveWidth = 60.0;

    for (
      double y = -waveHeight;
      y < size.height + waveHeight;
      y += waveHeight * 1.5
    ) {
      for (double x = -waveWidth; x < size.width + waveWidth; x += waveWidth) {
        // Première rangée d'arcs
        canvas.drawArc(
          Rect.fromCircle(center: Offset(x, y), radius: waveWidth / 2),
          math.pi,
          math.pi,
          false,
          paint,
        );

        // Deuxième rangée d'arcs (décalée)
        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(x + waveWidth / 2, y),
            radius: waveWidth / 4,
          ),
          math.pi,
          math.pi,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget de bordure décorative japonaise
class JapaneseBorder extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;

  const JapaneseBorder({
    super.key,
    required this.child,
    this.borderColor = AppColor.gold,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        ),
        // Coins décoratifs
        Positioned(
          top: 0,
          left: 0,
          child: _CornerDecoration(color: borderColor),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Transform.rotate(
            angle: math.pi / 2,
            child: _CornerDecoration(color: borderColor),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: _CornerDecoration(color: borderColor),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Transform.rotate(
            angle: math.pi,
            child: _CornerDecoration(color: borderColor),
          ),
        ),
      ],
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  final Color color;

  const _CornerDecoration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
      ),
    );
  }
}

/// Animation de particules flottantes (style sakura)
class FloatingParticles extends StatefulWidget {
  final int numberOfParticles;
  final Color particleColor;

  const FloatingParticles({
    super.key,
    this.numberOfParticles = 15,
    this.particleColor = AppColor.lightGold,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
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
          painter: _ParticlesPainter(
            animation: _controller.value,
            numberOfParticles: widget.numberOfParticles,
            color: widget.particleColor,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double animation;
  final int numberOfParticles;
  final Color color;

  _ParticlesPainter({
    required this.animation,
    required this.numberOfParticles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Seed fixe pour cohérence

    for (int i = 0; i < numberOfParticles; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final y = (baseY + (animation * speed * size.height)) % size.height;
      final radius = 2 + random.nextDouble() * 4;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
