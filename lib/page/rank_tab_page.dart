import 'package:flutter/material.dart';
import 'package:flutter_code/http/dao/rank_dao.dart';
import 'package:flutter_code/http/dao/video_mo.dart';
import 'package:flutter_code/model/rank_mo.dart';
import 'package:flutter_code/widget/hi_base_state.dart';
import 'package:flutter_code/widget/video_card.dart';

class RankTabPage extends StatefulWidget {
  final String sort;

  const RankTabPage({Key? key, required this.sort}) : super(key: key);
  @override
  _RankTabPageState createState() => _RankTabPageState();
}

class _RankTabPageState extends HiBaseTabState<RankMo, VideoMo, RankTabPage> {
  @override
  get contentChild => Container(
        child: ListView.builder(
          ///当item高度不足满屏高度时，也可以滑动触发下拉刷新
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return VideoCard(videoMo: dataList[index]);
          },
          padding: const EdgeInsets.only(top: 10),
          itemCount: dataList.length,
          controller: controller,
        ),
      );

  @override
  Future<RankMo> getData(int pageIndex) async {
    RankMo result = await RankDao.get(widget.sort, pageIndex: pageIndex);
    return result;
  }

  @override
  List<VideoMo> parseList(RankMo result) {
    return result.list ?? [];
  }
}
