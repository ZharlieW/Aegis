import 'dart:ui';
import 'package:flutter/material.dart';

/// Overlay for QR scan UI: semi-transparent mask with a clear center rectangle
/// and white L-shaped corners (like common scan UIs).
class ScanFrameOverlay extends StatelessWidget {
  const ScanFrameOverlay({
    super.key,
    this.scanAreaSize = 240,
    this.cornerLength = 24,
    this.cornerStrokeWidth = 3,
    this.maskColor = const Color(0x80000000),
  });

  /// Side length of the square scan area in the center.
  final double scanAreaSize;
  /// Length of each L-shaped corner arm.
  final double cornerLength;
  /// Stroke width of the corner lines.
  final double cornerStrokeWidth;
  /// Color of the semi-transparent mask outside the scan area.
  final Color maskColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final size = scanAreaSize.clamp(160.0, w < h ? w * 0.8 : h * 0.6);
        final left = (w - size) / 2;
        final top = (h - size) / 2;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, size, size),
          const Radius.circular(12),
        );
        return CustomPaint(
          size: Size(w, h),
          painter: _ScanFramePainter(
            scanRect: rect,
            cornerLength: cornerLength,
            cornerStrokeWidth: cornerStrokeWidth,
            maskColor: maskColor,
          ),
        );
      },
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  _ScanFramePainter({
    required this.scanRect,
    required this.cornerLength,
    required this.cornerStrokeWidth,
    required this.maskColor,
  });

  final RRect scanRect;
  final double cornerLength;
  final double cornerStrokeWidth;
  final Color maskColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Mask: full size minus center hole.
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()..addRRect(scanRect);
    final maskPath = Path.combine(PathOperation.difference, path, hole);
    canvas.drawPath(maskPath, Paint()..color = maskColor);

    // White L-shaped corners.
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerStrokeWidth
      ..strokeCap = StrokeCap.round;

    final r = scanRect.left;
    final t = scanRect.top;
    final l = scanRect.right;
    final b = scanRect.bottom;
    final c = cornerLength;

    // Top-left.
    canvas.drawPath(
      Path()
        ..moveTo(r, t + c)
        ..lineTo(r, t)
        ..lineTo(r + c, t),
      paint,
    );
    // Top-right.
    canvas.drawPath(
      Path()
        ..moveTo(l - c, t)
        ..lineTo(l, t)
        ..lineTo(l, t + c),
      paint,
    );
    // Bottom-right.
    canvas.drawPath(
      Path()
        ..moveTo(l, b - c)
        ..lineTo(l, b)
        ..lineTo(l - c, b),
      paint,
    );
    // Bottom-left.
    canvas.drawPath(
      Path()
        ..moveTo(r + c, b)
        ..lineTo(r, b)
        ..lineTo(r, b - c),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) {
    return oldDelegate.scanRect != scanRect ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.maskColor != maskColor;
  }
}
