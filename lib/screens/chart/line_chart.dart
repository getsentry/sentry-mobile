import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'line_chart_data.dart';
import 'line_chart_point.dart';

class LineChart extends StatelessWidget {
  LineChart({@required this.points, @required this.lineWidth, @required this.lineColor, @required this.gradientStart, @required this.gradientEnd});

  final List<LineChartPoint> points;
  final double lineWidth;
  final Color lineColor;
  final Color gradientStart;
  final Color gradientEnd;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter.create(points, lineWidth, lineColor, gradientStart, gradientEnd),
      child: Center(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter.create(List<LineChartPoint> points, double lineWidth, Color lineColor, this.gradientStart, this.gradientEnd) {
    data = _prepareData(points);
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor;
    linePadding = lineWidth / 2.0;
  }

  LineChartData data;
  Paint linePaint;
  double linePadding;
  Color gradientStart;
  Color gradientEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final screenSize = Size(size.width, size.height - linePadding * 2);

    final screenCoordinateX = (double x) {
      return _normalized(x, data.minX, data.maxX) * screenSize.width;
    };

    final screenCoordinateY = (double y) {
      return _normalized(y, data.minY, data.maxY) * screenSize.height;
    };

    final flipY = (double y) {
      return (size.height - linePadding) - y;
    };

    final pointsWithoutFirst = data.points.map((point) => LineChartPoint(point.x, point.y)).toList();
    final firstPoint = pointsWithoutFirst.removeAt(0);
    var previous = LineChartPoint(
        screenCoordinateX(firstPoint.x),
        screenCoordinateY(firstPoint.y)
    );

    // Line

    final linePath = Path();
    linePath.moveTo(
        previous.x, flipY(previous.y)
    );

    final updateLinePath = (int index, LineChartPoint point) {
      final x1 = previous.x;
      final y1 = previous.y;

      final x2 = screenCoordinateX(point.x);
      final y2 = screenCoordinateY(point.y);

      final cx1 = (x1 + x2) / 2;
      final cy1 = y1;

      final cx2 = (x1 + x2) / 2;
      final cy2 = y2;

      if (y1 == y2) {
        linePath.lineTo(x2, flipY(y2));
      } else {
        linePath.cubicTo(cx1, flipY(cy1), cx2, flipY(cy2), x2, flipY(y2));
      }
      previous = LineChartPoint(x2 , y2);
    };
    pointsWithoutFirst.asMap().forEach(updateLinePath);

    // Gradient

    final gradientPaint = _createGradientPaint(size, gradientStart, gradientEnd);
    final gradientPath = _createGradientPath(linePath, size, firstPoint);

    // Draw

    canvas.drawPath(gradientPath, gradientPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  // Helper

  Paint _createGradientPaint(Size size, Color gradientStart, Color gradientEnd) {
    return Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [gradientStart, gradientEnd],
      )
      ..style = PaintingStyle.fill;
  }

  Path _createGradientPath(Path linePath, Size size, LineChartPoint firstPoint) {
    final gradientPath = Path.from(linePath);
    gradientPath.lineTo(size.width, size.height);
    gradientPath.lineTo(0, size.height);
    gradientPath.lineTo(0, firstPoint.y);
    return gradientPath;
  }

  /// Normalize data points so they all start at zero. Return min/max values.
  LineChartData _prepareData(List<LineChartPoint> points) {
    var minX = double.maxFinite;
    var maxX = 0.0;
    var minY = double.maxFinite;
    var maxY = 0.0;

    for (final point in points)  {
      if (point.x < minX) {
        minX = point.x;
      }
      if (point.x > maxX) {
        maxX = point.x;
      }
      if (point.y < minY) {
        minY = point.y;
      }
      if (point.y > maxY) {
        maxY = point.y;
      }
    }
    return LineChartData(
      points.map((point) => LineChartPoint(point.x - minX, point.y - minY)).toList(),
      0,
      maxX - minX,
      0,
      maxY - minY
    );
  }

  double _normalized(double point, double min, double max) {
    if ((max - min) == 0) {
      return 0;
    }
    return (point - min) / (max - min);
  }
}