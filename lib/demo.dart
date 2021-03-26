import 'dart:math';

import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: Card(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(16),
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: GraphPaint(
                  hGridLines: 10,
                  dataLayer1: [30, 50, 80, 40, 0],
                  dataLayer2: [100, 80, 60, 40, 50],
                  dataLayer3: [60, 30, 40, 45, 60, 80],
                ),
              )),
        ),
      ),
    ));
  }
}

class GraphPaint extends CustomPainter {
  GraphPaint({@required this.hGridLines, @required this.dataLayer1, @required this.dataLayer2, @required this.dataLayer3})
      : gridLinePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.grey.shade300
          ..strokeWidth = 2;

  final int hGridLines;
  final List<double> dataLayer1, dataLayer2, dataLayer3;
  final Paint gridLinePaint;
  final Color c1 = const Color(0xe0b5bffd);
  final Color c2 = const Color(0xe09362FA);
  final Color c3 = const Color(0xe0e791f7);
  double maxValue;

  @override
  void paint(Canvas canvas, Size size) {
    maxValue = [...dataLayer1, ...dataLayer2, ...dataLayer3].reduce(max);
    maxValue = maxValue + maxValue * .3;

    drawHorizontalGridLines(size, canvas);
    // drawVerticalGridLines(size, canvas);

    final shade1 = Paint()..shader = LinearGradient(colors: [c1, c2]).createShader(Offset.zero & size);
    drawGraphLayer(size, canvas, dataLayer1, shade1);

    final shade2 = Paint()..shader = LinearGradient(colors: [c2, c3]).createShader(Offset.zero & size);
    drawGraphLayer(size, canvas, dataLayer2, shade2);

    final shade3 = Paint()..shader = LinearGradient(colors: [c1, c3]).createShader(Offset.zero & size);
    drawGraphLayer(size, canvas, dataLayer3, shade3);
  }

  void drawGraphLayer(Size size, Canvas canvas, List<double> values, Paint fill) {
    if (values == null || values.length < 2) {
      print('invalid data points -> $values');
      return;
    }

    final ry = size.height / maxValue;
    final blocX = size.width / (values.length - 1);

    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, -values[0] * ry);

    for (var i = 1; i < values.length; i++) {
      final px = blocX * i;
      final py = -values[i] * ry;
      final h1x = blocX * (i - 1) + blocX * .5;
      final h1y = -values[i - 1] * ry;
      final h2x = px - blocX * .5;
      final h2y = py;

      path.cubicTo(h1x, h1y, h2x, h2y, px, py);
    }

    path
      ..lineTo(size.width, 0)
      ..close();

    path = path.shift(Offset(0, size.height));

    canvas.drawPath(path, fill);
  }

  void drawHorizontalGridLines(Size size, Canvas canvas) {
    for (var i = 0; i <= hGridLines; i++) {
      final ly = (size.height / hGridLines) * (i + 1);
      final hLine = Path()
        ..moveTo(0, ly)
        ..lineTo(size.width, ly);
      canvas.drawPath(hLine, gridLinePaint);
    }
  }

  void drawVerticalGridLines(Size size, Canvas canvas) {
    for (var i = 0; i <= hGridLines; i++) {
      final lx = (size.width / hGridLines) * i;
      final vLine = Path()
        ..moveTo(lx, 0)
        ..lineTo(lx, size.height);
      canvas.drawPath(vLine, gridLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
