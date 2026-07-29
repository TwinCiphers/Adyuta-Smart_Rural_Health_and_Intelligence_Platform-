import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SoftBackgroundLayout extends StatelessWidget {
  final Widget child;
  final bool hasScrollBody;

  const SoftBackgroundLayout({
    super.key,
    required this.child,
    this.hasScrollBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Base Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE6F7F6), // Very light teal/cyan (+3% brightness from original)
                  Color(0xFFF4FDFD),
                  Color(0xFFE2F3F3),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Abstract Waves via CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),

          // The main content
          SafeArea(
            bottom: false,
            child: hasScrollBody
                ? child
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: child,
                  ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Top Wave
    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(size.width, 0);
    topPath.lineTo(size.width, size.height * 0.25);
    topPath.quadraticBezierTo(
        size.width * 0.7, size.height * 0.15, size.width * 0.5, size.height * 0.2);
    topPath.quadraticBezierTo(
        size.width * 0.2, size.height * 0.25, 0, size.height * 0.1);
    topPath.close();
    canvas.drawPath(topPath, paint);

    // Bottom Wave
    final bottomPaint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;
      
    final bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.lineTo(size.width, size.height);
    bottomPath.lineTo(size.width, size.height * 0.85);
    bottomPath.quadraticBezierTo(
        size.width * 0.7, size.height * 0.75, size.width * 0.4, size.height * 0.85);
    bottomPath.quadraticBezierTo(
        size.width * 0.15, size.height * 0.95, 0, size.height * 0.8);
    bottomPath.close();
    canvas.drawPath(bottomPath, bottomPaint);

    // Decorative + Crosses
    _drawCross(canvas, Offset(size.width * 0.85, size.height * 0.3), 15);
    _drawCross(canvas, Offset(size.width * 0.1, size.height * 0.7), 20);
    _drawCross(canvas, Offset(size.width * 0.88, size.height * 0.88), 12);
  }

  void _drawCross(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.15)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
      
    canvas.drawLine(
        Offset(center.dx - size / 2, center.dy), 
        Offset(center.dx + size / 2, center.dy), 
        paint);
    canvas.drawLine(
        Offset(center.dx, center.dy - size / 2), 
        Offset(center.dx, center.dy + size / 2), 
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
