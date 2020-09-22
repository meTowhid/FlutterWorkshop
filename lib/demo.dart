import 'package:flutter/material.dart';
import 'package:flutter_workshop/widget/bumped_bottom_nav.dart';
import 'package:flutter_workshop/widget/nav_item.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          _buildScreen('Screen 1'),
          _buildScreen('Screen 2'),
          _buildScreen('Screen 3'),
          _buildScreen('Screen 4'),
          _buildScreen('Screen 5'),
        ],
      ),
      bottomNavigationBar: BumpedBottomNav(
        items: [
          NavItem(icon: Icons.bubble_chart, title: 'Home'),
          NavItem(icon: Icons.landscape, title: 'Search'),
          NavItem(icon: Icons.brightness_3, title: 'Event'),
          NavItem(icon: Icons.bubble_chart, title: 'Home'),
          NavItem(icon: Icons.landscape, title: 'Search'),
        ],
        callback: (int i) => pageController.jumpToPage(i),
        initialSelectedIndex: 2,
      ),
    );
  }

  _buildScreen(String message) {
    return Container(
      alignment: Alignment.center,
      child: Text(message, style: TextStyle(fontSize: 30, color: Colors.black)),
    );
  }
}
