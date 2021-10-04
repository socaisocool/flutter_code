import 'package:flutter/material.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/dao/video_detial_dao.dart';
import 'package:flutter_code/model/video_detial_mo.dart';
import 'package:flutter_code/model/video_mo.dart';
import 'package:flutter_code/page/expand_content.dart';
import 'package:flutter_code/utils/toast_util.dart';
import 'package:flutter_code/utils/view_util.dart';
import 'package:flutter_code/widget/hi_tab.dart';
import 'package:flutter_code/widget/navigation_bar.dart';
import 'package:flutter_code/widget/video_header.dart';
import 'package:flutter_code/widget/video_large_card.dart';
import 'package:flutter_code/widget/video_tool_bar.dart';
import 'package:flutter_code/widget/video_view.dart';

class VideoDetialPage extends StatefulWidget {
  final VideoMo videoMo;

  const VideoDetialPage({Key? key, required this.videoMo}) : super(key: key);

  @override
  _VideoDetialPageState createState() => _VideoDetialPageState();
}

class _VideoDetialPageState extends State<VideoDetialPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  VideoDetialMo? _videoDetialMo;
  VideoMo? videoMo;
  List<VideoMo> videoList = [];

  @override
  void initState() {
    super.initState();
    videoMo = widget.videoMo;
    _loadNetData();
  }

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
          const Padding(padding: EdgeInsets.only(top: 8)),
          Flexible(
              child: Container(
            color: Colors.white,
            child: TabBarView(
              controller: _controller,
              children: [
                _buildDetialList(),
                Container(
                  child: Text('敬请期待'),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  _videoView() {
    return VideoView(
      videoUrl: videoMo?.url ?? "",
      cover: videoMo?.cover ?? "",
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

  _buildDetialList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        ...buildContents(),
      ],
    );
  }

  buildContents() {
    return [
      Container(
        child: VideoHeader(
          owner: videoMo!.owner,
        ),
      ),
      ExpandContent(mo: videoMo!),
      VideoToolBar(
          detialMo: _videoDetialMo,
          videoMo: videoMo!,
          onLike: _onLike,
          onUnLike: _onUnLike,
          onCoin: _onCoin,
          onFavorite: _onFavorite,
          onShare: _onShare),
      ..._buildVideoList(),
    ];
  }

  void _loadNetData() async {
    try {
      VideoDetialMo result = await VideoDetialDao.get(videoMo!.vid);
      print("VideoDetialPage data :$result");
      if (result != null) {
        setState(() {
          _videoDetialMo = result;
          videoMo = result.videoInfo;
          videoList = result.videoList ?? [];
        });
      }
    } on NeedAuth catch (e) {
      // ignore: avoid_print
      print(e);
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _onLike() {}

  void _onUnLike() {}

  void _onCoin() {}

  void _onFavorite() {}

  void _onShare() {}

  _buildVideoList() {
    return videoList
        .map((videoMo) => VideoLargeCard(videoMo: videoMo))
        .toList();
  }
}
