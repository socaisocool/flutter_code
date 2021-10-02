import 'package:flutter/material.dart';
import 'package:statusbarmanager/statusbarmanager.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class NavigatorBar extends StatelessWidget {
  final StatusStyle stateStyle;
  final Color color;
  final Widget child;

  const NavigatorBar({
    Key? key,
    this.stateStyle = StatusStyle.DARK_CONTENT,
    this.color = Colors.transparent,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusMode = stateStyle == StatusStyle.DARK_CONTENT
        ? Brightness.dark
        : Brightness.light;
    //获取状态栏的高度
    var top = MediaQuery.of(context).padding.top;
    return StatusBarManager(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: top),
        child: child,
        decoration: BoxDecoration(color: color),
      ),
      translucent: true,
      statusBarColor: Colors.transparent,
      statusBarBrightness: statusMode,
    );
  }
}
