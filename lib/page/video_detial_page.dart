import 'package:flutter/material.dart';
import 'package:flutter_code/http/dao/video_mo.dart';
import 'package:flutter_code/utils/view_util.dart';
import 'package:flutter_code/widget/hi_tab.dart';
import 'package:flutter_code/widget/navigation_bar.dart';
import 'package:flutter_code/widget/video_view.dart';

class VideoDetialPage extends StatefulWidget {
  final VideoMo videoModel;

  const VideoDetialPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoDetialPageState createState() => _VideoDetialPageState();
}

class _VideoDetialPageState extends State<VideoDetialPage>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    _controller = TabController(length: 2, vsync: this);
    return Scaffold(
      body: Column(
        children: [
          NavigatorBar(
            newColor: Colors.black,
            statusStyle: NavStatusStyle.LIGHT_CONTENT,
            child: _videoView(),
          ),
          _buildTabNavigation(),
        ],
      ),
    );
  }

  _videoView() {
    VideoMo model = widget.videoModel;
    return VideoView(
      videoUrl: model.url,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }

  //在视频的上面再叠一层控件
  videoAppBar() {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
      child: Row(
        children: [
          const BackButton(
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(
                Icons.live_tv_rounded,
                color: Colors.white,
                size: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        height: 40,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.live_tv_rounded,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }

  _tabBar() {
    List<Widget> tabs = {"简介", "评论288"}.map((name) {
      return Tab(text: name);
    }).toList();
    return HiTopTab(
      tabs,
      controller: _controller,
      fontSize: 16,
      insets: 13,
      unSelectedLabelColor: Colors.black54,
    );
  }
}
