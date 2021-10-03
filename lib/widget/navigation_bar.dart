import 'package:flutter/material.dart';
import 'package:flutter_code/manger/flutter_statusbar_manager.dart';
import 'package:statusbarmanager/statusbarmanager.dart';

enum NavStatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class NavigatorBar extends StatelessWidget {
  final NavStatusStyle statusStyle;
  final Color oldColor;
  final Color newColor;
  final Widget child;
  final double height;
  final bool userOld;

  const NavigatorBar({
    Key? key,
    this.userOld = true,
    this.statusStyle = NavStatusStyle.DARK_CONTENT,
    this.oldColor = Colors.white,
    required this.child,
    this.height = 46,
    this.newColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userOld
        ? _supportByOldStatusBarManager(context)
        : _supportByNewStatusBarManager(context);
  }

  Widget _supportByNewStatusBarManager(BuildContext context) {
    var statusMode = statusStyle == NavStatusStyle.DARK_CONTENT
        ? Brightness.dark
        : Brightness.light;
    //获取状态栏的高度
    var top = MediaQuery.of(context).padding.top;
    return StatusBarManager(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: top),
        child: child,
        decoration: BoxDecoration(color: newColor),
      ),
      translucent: true,
      statusBarColor: Colors.transparent,
      statusBarBrightness: statusMode,
    );
  }

  Widget _supportByOldStatusBarManager(BuildContext context) {
    //状态栏高度
    _statusBarInit();
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(
        color: oldColor,
      ),
    );
  }

  void _statusBarInit() {
    FlutterStatusbarManager.setColor(oldColor, animated: false);
    FlutterStatusbarManager.setStyle(statusStyle == NavStatusStyle.DARK_CONTENT
        ? StatusBarStyle.DARK_CONTENT
        : StatusBarStyle.LIGHT_CONTENT);
  }
}
