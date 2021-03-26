import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 5), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      })
      ..addStatusListener((state) => print('$state'))
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: GraphPaint(animation.value),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'THINK\nOUTSIDE\nYOUR\nBOX',
                    style: TextStyle(
                      letterSpacing: 15,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'roboto',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GraphPaint extends CustomPainter {
  GraphPaint(this.p);

  final double p;
  Paint framePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeWidth = 9;
  final random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    Path animatedPath = Path()
      ..moveTo(423.27 + 5 * p, 35.91 + 10 * p)
      ..cubicTo(423.27, 35.91, 356.71, 140.69, 332.76 - 9 * p, 135.47 - 10 * p)
      ..cubicTo(308.81, 130.25, 361.98, 52.03, 332.76 + 5 * p, 51.13 + 5 * p)
      ..cubicTo(303.54, 50.23, 289.57, 170.39, 244.84 - 5 * p, 162.38 - 20 * p)
      ..cubicTo(200.1, 154.38, 321.02, 12.1, 283.85 - 5 * p, 0 - 40 * p)
      ..cubicTo(246.67, -12.1, 209.15, 139.32, 179.66 + 8 * p, 135.47 + 50 * p)
      ..cubicTo(150.18, 131.62, 204.09, 37.42, 179.66 - 9 * p, 35.91 - 9 * p)
      ..cubicTo(155.24, 34.4, 154.84, 112.15, 132.16 + 7 * p, 106.58 + 33 * p)
      ..cubicTo(109.48, 101.02, 147.49, 52.54, 124.9 - 9 * p, 45.4 - 20 * p)
      ..cubicTo(102.31, 38.26, 51.06, 72.54, 0 + 5 * p, 140.7 + 25 * p);

    double frameWidth = size.width * .65;
    double frameHeight = size.height * .95;

    Path backHalf = Path()
      ..moveTo(frameWidth / 2, 0)
      ..lineTo(0, 0)
      ..relativeLineTo(0, frameHeight)
      ..relativeLineTo(frameWidth / 2, 0);
    backHalf = backHalf.shift(Offset(size.width / 2 - frameWidth / 2, 0));

    canvas.drawPath(backHalf, framePaint);

    drawBlobbyPath(
      canvas: canvas,
      path: animatedPath.shift(Offset(-20, 110)),
      colors: [
        const Color(0xe091e6f6),
        const Color(0xe03f456f),
      ],
      copies: 1000,
      startRadius: 30 - 5 * p,
      endRadius: 30 + 10 * p,
      // reverseDirection: true,
    );

    Path frontHalf = Path()
      ..moveTo(0, 0)
      ..relativeLineTo(frameWidth / 2, 0)
      ..relativeLineTo(0, frameHeight)
      ..relativeLineTo(-frameWidth / 2, 0);
    frontHalf = frontHalf.shift(Offset(size.width / 2, 0));

    canvas.drawPath(frontHalf, framePaint);
  }

  void drawBlobbyPath({
    @required Canvas canvas,
    @required Path path,
    List<Color> colors,
    Alignment begin: Alignment.topLeft,
    Alignment end: Alignment.bottomCenter,
    double startRadius = 10,
    double endRadius = 30,
    int copies = 100,
    bool reverseDirection = false,
  }) {
    List<int> l = List<int>.generate(copies, (index) => index + 1);
    if (reverseDirection) l = l.reversed.toList(growable: false);
    l.forEach((i) {
      final radius = startRadius + (endRadius - startRadius) / copies * i + 10 * p;
      final circleCenter = calculateCircleCenter(path, i / copies);
      final shaderArea = Rect.fromCircle(center: circleCenter, radius: radius);
      final shade = Paint()..shader = LinearGradient(colors: colors, begin: begin, end: end).createShader(shaderArea);
      canvas.drawCircle(circleCenter, radius, shade);
    });
  }

  Offset calculateCircleCenter(Path path, double percent) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    percent = pathMetric.length * percent;
    Tangent pos = pathMetric.getTangentForOffset(percent);
    return pos.position;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
