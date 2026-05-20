import 'dart:math';
import 'package:flutter/material.dart';

/// 仪表盘组件
class GaugeChart extends StatelessWidget {
  /// 当前值
  final double value;

  /// 最大值
  final double maxValue;

  /// 标签
  final String label;

  /// 单位
  final String unit;

  /// 颜色
  final Color color;

  /// 尺寸
  final double size;

  const GaugeChart({
    super.key,
    required this.value,
    required this.maxValue,
    required this.label,
    required this.unit,
    required this.color,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue * 100).clamp(0.0, 100.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: size,
              height: size * 0.6,
              child: CustomPaint(
                painter: _GaugePainter(
                  percentage: percentage,
                  color: color,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size * 0.15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${value.toStringAsFixed(value is int ? 0 : 1)}$unit',
                          style: TextStyle(
                            fontSize: size * 0.18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 仪表盘画家
class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  _GaugePainter({
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width / 2, size.height) - 10;

    // 背景弧
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // 前景弧
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // 绘制背景弧（180度）
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    // 绘制前景弧
    final sweepAngle = pi * percentage / 100;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      fgPaint,
    );

    // 绘制刻度
    _drawTicks(canvas, center, radius);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius) {
    final tickPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2;

    const tickCount = 5;
    final tickRadius = radius - 20;

    for (int i = 0; i <= tickCount; i++) {
      final angle = pi + (pi * i / tickCount);
      final inner = Offset(
        center.dx + (tickRadius - 5) * cos(angle),
        center.dy + (tickRadius - 5) * sin(angle),
      );
      final outer = Offset(
        center.dx + tickRadius * cos(angle),
        center.dy + tickRadius * sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
