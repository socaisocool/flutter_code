// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code/http/dao/home_dao.dart';
import 'package:flutter_code/http/dao/video_mo.dart';
import 'package:flutter_code/model/home_mo.dart';
import 'package:flutter_code/widget/hi_banner.dart';
import 'package:flutter_code/widget/hi_base_state.dart';
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

class _HomeTopTabPageState
    extends HiBaseTabState<HomeMo, VideoMo, HomeTopTabPage> {
  @override
  void initState() {
    super.initState();
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

  @override
  bool get wantKeepAlive => true;

  @override
  get contentChild => StaggeredGridView.countBuilder(
        controller: controller,
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2, //
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          if (index == 0 && widget.bannerMoData != null) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 8), child: _banner());
          } else {
            return VideoCard(videoMo: dataList[index]);
          }
        },
        staggeredTileBuilder: (int index) {
          if (widget.bannerMoData != null && index == 0) {
            return const StaggeredTile.fit(2); //第一个数据占两列
          } else {
            return const StaggeredTile.fit(1); //其余都占一列
          }
        },
      );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result =
        await HomeDao.get(widget.categoryName, pageIndex: pageIndex);
    return result;
  }

  @override
  List<VideoMo> parseList(HomeMo result) {
    return result.videoList;
  }
}
