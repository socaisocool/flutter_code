import 'package:flutter/material.dart';
import 'package:flutter_code/utils/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

///顶部tab切换组件
class HiTopTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color? unSelectedLabelColor;

  const HiTopTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 12,
      this.borderWidth = 3,
      this.insets = 15,
      this.unSelectedLabelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: unSelectedLabelColor,
      labelStyle: TextStyle(fontSize: fontSize),
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.round,
          insets: EdgeInsets.only(left: insets, right: insets),
          borderSide: BorderSide(color: primary, width: borderWidth)),
      controller: controller,
    );
  }
}
