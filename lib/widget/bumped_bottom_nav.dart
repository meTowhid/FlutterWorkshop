import 'package:flutter/material.dart';
import 'package:flutter_workshop/widget/nav_item.dart';
import 'package:flutter_workshop/widget/bump_painter.dart';

class BumpedBottomNav extends StatefulWidget {
  final List<NavItem> items;
  final Function(int index) callback;
  final int initialSelectedIndex;

  BumpedBottomNav({this.items, this.callback, this.initialSelectedIndex = 0});

  @override
  _BumpedBottomNavState createState() => _BumpedBottomNavState();
}

class _BumpedBottomNavState extends State<BumpedBottomNav> {
  double begin = 0;
  double selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex.toDouble();
    begin = selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96, // height of bottom navigation bar
      child: Column(
        children: <Widget>[
          TweenAnimationBuilder(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            tween: Tween<double>(begin: begin, end: selectedIndex),
            builder: (context, value, child) => CustomPaint(
              painter: BumpPainter(currentPosition: value, totalItem: widget.items.length),
              size: Size(MediaQuery.of(context).size.width, 40), // custom drawing size : screenWidth x 40
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items.asMap().entries.map((i) => _buildNavItem(i.key, i.value)).toList(),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, NavItem item) => InkWell(
        child: Column(children: [Icon(item.icon), Text(item.title)]),
        onTap: () => setState(() {
          selectedIndex = index.toDouble();
          widget.callback.call(index);
        }),
      );
}

