import 'package:flutter/material.dart';
import 'package:flutter_code/model/home_mo.dart';

class VideoDetialPage extends StatefulWidget {
  final VideoMo? videoModel;

  const VideoDetialPage({Key? key, this.videoModel}) : super(key: key);

  @override
  _VideoDetialPageState createState() => _VideoDetialPageState();
}

class _VideoDetialPageState extends State<VideoDetialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Text('视频详情页,vid:${widget.videoModel?.vid ?? ""}'),
      ),
    );
  }
}
