import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom painter for hill background
class HillBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withOpacity(0.1);

    final path = Path();

    // First hill (back)
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.65,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second hill (front)
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withOpacity(0.15);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.85);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.7,
      size.width * 0.6,
      size.height * 0.8,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.9,
      size.width,
      size.height * 0.85,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget that displays hill background
class HillBackgroundWidget extends StatelessWidget {
  const HillBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: HillBackground(), child: Container());
  }
}
