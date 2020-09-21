import 'package:flutter/material.dart';
import 'package:flutter_workshop/home.dart';

void main() {
  runApp(ExperimentalApp());
}

class ExperimentalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false);
  }
}
