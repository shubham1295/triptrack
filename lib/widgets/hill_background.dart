import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Scenic hill background with layered hills, gradient sky, and pointy trees.
/// Designed for login/landing screens with adaptive light/dark modes.
class HillBackground extends CustomPainter {
  final bool isDark;

  HillBackground({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // === Sky Gradient ===
    final Rect skyRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                Colors.indigo.shade900.withOpacity(0.6),
                Colors.blueGrey.shade900.withOpacity(0.25),
              ]
            : [
                AppColors.primary.withOpacity(0.15),
                Colors.white.withOpacity(0.0),
              ],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // === Helper: Hill Drawing ===
    void drawHill(
      double startY,
      double control1X,
      double control1Y,
      double control2X,
      double control2Y,
      double endY,
      Color color,
    ) {
      final path = Path()
        ..moveTo(0, startY)
        ..quadraticBezierTo(control1X, control1Y, control2X, control2Y)
        ..quadraticBezierTo(size.width * 0.85, endY, size.width, startY)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();

      final paint = Paint()..color = color;
      canvas.drawPath(path, paint);
    }

    // Base color depending on theme
    final baseColor = isDark ? Colors.blueGrey.shade700 : AppColors.primary;

    // === Hills ===
    drawHill(
      size.height * 0.75,
      size.width * 0.25,
      size.height * 0.55,
      size.width * 0.55,
      size.height * 0.7,
      size.height * 0.75,
      baseColor.withOpacity(isDark ? 0.10 : 0.08),
    );

    drawHill(
      size.height * 0.82,
      size.width * 0.3,
      size.height * 0.65,
      size.width * 0.65,
      size.height * 0.8,
      size.height * 0.82,
      baseColor.withOpacity(isDark ? 0.14 : 0.12),
    );

    drawHill(
      size.height * 0.9,
      size.width * 0.35,
      size.height * 0.75,
      size.width * 0.65,
      size.height * 0.88,
      size.height * 0.9,
      baseColor.withOpacity(isDark ? 0.20 : 0.18),
    );

    // === Pointy Trees ===
    void drawTree(double x, double y, double height, double width) {
      final trunkPaint = Paint()
        ..color = (isDark ? Colors.brown.shade400 : Colors.brown.shade700)
            .withOpacity(0.9);
      final foliagePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.green.shade800, Colors.green.shade900]
              : [Colors.green.shade500, Colors.green.shade700],
        ).createShader(Rect.fromLTWH(x - width / 2, y - height, width, height));

      // Trunk
      final trunkHeight = height * 0.2;
      canvas.drawRect(
        Rect.fromLTWH(
          x - width * 0.1,
          y - trunkHeight,
          width * 0.2,
          trunkHeight,
        ),
        trunkPaint,
      );

      // Foliage (triangle shape)
      final path = Path()
        ..moveTo(x, y - height)
        ..lineTo(x - width / 2, y - trunkHeight)
        ..lineTo(x + width / 2, y - trunkHeight)
        ..close();

      canvas.drawPath(path, foliagePaint);
    }

    // Draw multiple trees (foreground mostly)
    final trees = [
      // x position, y position, height, width
      [0.10, 0.86, 35.0, 20.0],
      [0.18, 0.75, 30.0, 18.0],
      [0.25, 0.90, 32.0, 19.0],
      [0.45, 0.78, 38.0, 24.0],
      [0.58, 0.86, 34.0, 21.0],
      [0.68, 0.85, 30.0, 18.0],
      [0.88, 0.89, 37.0, 22.0],
      [0.95, 0.84, 35.0, 21.0],
    ];

    for (var t in trees) {
      drawTree(size.width * t[0], size.height * t[1], t[2], t[3]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget for scenic background that adapts to theme brightness
class HillBackgroundWidget extends StatelessWidget {
  const HillBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      painter: HillBackground(isDark: isDark),
      child: Container(),
    );
  }
}
