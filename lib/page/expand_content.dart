import 'package:flutter/material.dart';
import 'package:flutter_code/model/video_mo.dart';
import 'package:flutter_code/utils/view_util.dart';

//参考ExpandTitle的源码
class ExpandContent extends StatefulWidget {
  final VideoMo mo;

  const ExpandContent({Key? key, required this.mo}) : super(key: key);
  @override
  _ExpandContentState createState() => _ExpandContentState();
}

class _ExpandContentState extends State<ExpandContent>
    with SingleTickerProviderStateMixin {
  bool _expand = false;
  //创建一个动画
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  //创建一个动画控制
  static AnimationController? _controller;
  //生成动画高度值
  Animation<double>? _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller?.drive(_easeInTween);
    _controller?.addListener(() {
      //监听动画值的变化
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        _controller?.forward();
      } else {
        _controller?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          const Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDesc(),
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            widget.mo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          const Padding(padding: EdgeInsets.only(left: 15)),
          Icon(_expand
              ? Icons.keyboard_arrow_up_sharp
              : Icons.keyboard_arrow_down_sharp)
        ],
      ),
    );
  }

  _buildInfo() {
    var style = const TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.mo.createTime.length > 10
        ? widget.mo.createTime.substring(5, 10)
        : widget.mo.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        const Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Text(
          '   $dateStr',
          style: style,
        ),
      ],
    );
  }

  _buildDesc() {
    var child = _expand
        ? Text(
            widget.mo.desc,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null;
    //构建动画的通用widget
    return AnimatedBuilder(
        animation: _controller!.view,
        builder: (BuildContext context, Widget? innerChild) {
          return Align(
            heightFactor: _heightFactor?.value,
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        });
  }
}
