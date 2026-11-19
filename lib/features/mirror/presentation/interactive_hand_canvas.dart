import 'package:flutter/material.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';

class InteractiveHandCanvas extends StatelessWidget {
  final String signId;
  final String handEmoji;
  final bool isMirror;

  const InteractiveHandCanvas({
    super.key,
    required this.signId,
    required this.handEmoji,
    this.isMirror = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: isMirror ? -1.0 : 1.0,
      child: CustomPaint(
        painter: _HandSkeletonPainter(signId: signId),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                handEmoji,
                style: const TextStyle(fontSize: 84),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandSkeletonPainter extends CustomPainter {
  final String signId;
  _HandSkeletonPainter({required this.signId});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Subtle alignment grid circles
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, size.width * 0.35, gridPaint);
    canvas.drawCircle(center, size.width * 0.22, gridPaint);

    // Hand tracking landmark nodes (simulated vector overlay)
    final nodePaint = Paint()
      ..color = IsharaColors.accentAmber.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = IsharaColors.accentAmber.withValues(alpha: 0.35)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final landmarks = [
      Offset(center.dx, center.dy + 70), // wrist
      Offset(center.dx - 40, center.dy + 30), // thumb base
      Offset(center.dx - 60, center.dy - 10), // thumb tip
      Offset(center.dx - 20, center.dy - 65), // index tip
      Offset(center.dx + 5, center.dy - 75),  // middle tip
      Offset(center.dx + 30, center.dy - 60), // ring tip
      Offset(center.dx + 52, center.dy - 40), // pinky tip
    ];

    for (int i = 0; i < landmarks.length; i++) {
      canvas.drawCircle(landmarks[i], 4.5, nodePaint);
      if (i > 0) {
        canvas.drawLine(landmarks[0], landmarks[i], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
