import 'package:flutter/material.dart';
import 'package:flutter_workshop/demo.dart';

void main() {
  runApp(WorkshopApp());
}

class WorkshopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Demo(), debugShowCheckedModeBanner: false);
  }
}
