// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/dao/home_dao.dart';
import 'package:flutter_code/model/home_mo.dart';
import 'package:flutter_code/utils/toast_util.dart';
import 'package:flutter_code/widget/hi_banner.dart';
import 'package:flutter_code/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTopTabPage extends StatefulWidget {
  final String categoryName;
  List<BannerMo>? bannerMoData;
  HomeTopTabPage({Key? key, required this.categoryName, this.bannerMoData})
      : super(key: key);

  @override
  _HomeTopTabPageState createState() => _HomeTopTabPageState();
}

class _HomeTopTabPageState extends State<HomeTopTabPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  int pageIndex = 1;
  List<VideoMo> videoList = [];
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var dis =
          _controller.position.maxScrollExtent - _controller.position.pixels;
      if (dis < 300 && !isLoading) {
        _loadNetData(loadMore: true);
      }
    });
    _loadNetData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: StaggeredGridView.countBuilder(
              controller: _controller,
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2, //
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                if (index == 0 && widget.bannerMoData != null) {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _banner());
                } else {
                  return VideoCard(videoMo: videoList[index]);
                }
              },
              staggeredTileBuilder: (int index) {
                if (widget.bannerMoData != null && index == 0) {
                  return const StaggeredTile.fit(2); //第一个数据占两列
                } else {
                  return const StaggeredTile.fit(1); //其余都占一列
                }
              },
            )),
      ),
      onRefresh: _loadNetData,
      color: Colors.deepOrangeAccent,
      backgroundColor: Colors.white,
    );
  }

  _banner() {
    return HiBanner(
      widget.bannerMoData,
      bannerItemClick: _bannerClick,
    );
  }

  _bannerClick(BannerMo bannerItem) {
    if (bannerItem.type == 'video') {
      // HiNavigator.getObj().onJumpTo(RouteStatus.detial,
      //     args: {"videoMo": bannerItem});
    }
  }

  Future _loadNetData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    try {
      int currentPageIn = pageIndex += loadMore ? 1 : 0;
      HomeMo result =
          await HomeDao.get(widget.categoryName, pageIndex: currentPageIn);
      setState(() {
        if (loadMore) {
          videoList = [...videoList, ...result.videoList];
          if (result.videoList.isNotEmpty) {
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        isLoading = false;
      });
    } on NeedLogin catch (e) {
      print(e.message);
      showWarnToast(e.message);
      isLoading = false;
    } on NeedAuth catch (e) {
      print(e.message);
      showWarnToast(e.message);
      isLoading = false;
    } on HiNetError catch (e) {
      print(e.message);
      isLoading = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
