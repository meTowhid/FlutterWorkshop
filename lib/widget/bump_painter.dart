import 'package:flutter/material.dart';

class BumpPainter extends CustomPainter {
  final Paint blackLinePaint, yellowFillPaint, blueFillPaint;
  final double currentPosition;
  final int totalItem;

  BumpPainter({@required this.currentPosition, @required this.totalItem})
      : blackLinePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black
    ..strokeWidth = 3,
        yellowFillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.amber,
        blueFillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Color(0Xff15233B);

  // fading gradient used to fade the line
  final Gradient fadedGradient = LinearGradient(
    colors: <Color>[
      Colors.black.withOpacity(0.05),
      Colors.black.withOpacity(1.0),
      Colors.black.withOpacity(1.0),
      Colors.black.withOpacity(0.05),
    ],
    stops: [
      0.0,
      0.15,
      0.85,
      1.0,
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    /*
    canvas height is 40.
    most of the values are proportion to height as because it makes them dynamic to the height.
    i've calculated the static values so that you can modify them with ease.
    */

    double bumpWidth = size.height * .7; // 40 * .7 = 28
    // if the bump is bigger than the line will be thinner and vise versa
    double bumpHeight = size.height * .5; //  40 * .5 = 20 -> right now its half of the height

    double filledAreaHeight = size.height - bumpHeight; // subtracting the bump area we get the blue color filled area height

    double itemWidth = size.width / totalItem; // each stops distance
    double mid = itemWidth / 2 + itemWidth * currentPosition; // mid point of each icon
    double start = mid - bumpWidth; // bumps start X position
    double end = mid + bumpWidth; // bumps end X position

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, filledAreaHeight), blueFillPaint);

    Offset p1 = Offset(start, 0), // start point : first half
        c1 = Offset(start + bumpWidth * .5, 0), // first control point : first half
        c2 = Offset(start + bumpWidth * .4, bumpHeight), // second control point : first half
        p2 = Offset(mid, bumpHeight), // mid point
        c3 = Offset(end - bumpWidth * .4, bumpHeight), // first control point : second half
        c4 = Offset(end - bumpWidth * .5, 0), // second control point : second half
        p3 = Offset(end, 0); // end point

    Path blueFilledArea = Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy)
      ..cubicTo(c3.dx, c3.dy, c4.dx, c4.dy, p3.dx, p3.dy)
      ..close();

    // notice that most the points above are positioned with Y value 0.
    // Its for the ease of calculation.
    // So now we have to shift it down.
    Path shiftedPath = blueFilledArea.shift(Offset(0, filledAreaHeight));
    canvas.drawPath(shiftedPath, blueFillPaint); // its time to draw

    Path line = Path()
      ..moveTo(0, 0)
      ..lineTo(p1.dx, p1.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy)
      ..cubicTo(c3.dx, c3.dy, c4.dx, c4.dy, p3.dx, p3.dy)
      ..lineTo(size.width, 0);

    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    blackLinePaint..shader = fadedGradient.createShader(rect);

    // Shifting down the line path
    shiftedPath = line.shift(Offset(0, filledAreaHeight));
    canvas.drawPath(shiftedPath, blackLinePaint); // its time to draw

    // BALL SECTION
    double ballRadius = size.height * .25; // 40 * .25 = 10
    Offset circleCenter = Offset(mid, filledAreaHeight);
    canvas.drawCircle(circleCenter, ballRadius, yellowFillPaint); // its time to draw
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
