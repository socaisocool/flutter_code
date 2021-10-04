import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code/model/video_mo.dart';
import 'package:flutter_code/navigator/hi_navigator.dart';
import 'package:flutter_code/utils/format_util.dart';
import 'package:flutter_code/utils/view_util.dart';

class VideoLargeCard extends StatelessWidget {
  final VideoMo videoMo;

  const VideoLargeCard({Key? key, required this.videoMo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HiNavigator.getObj()
            .onJumpTo(RouteStatus.detial, args: {"videoMo": videoMo});
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: const EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLiner(context)),
        child: Row(
          children: [
            _itemImage(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoMo.cover, width: height * (16 / 9), height: height),
          Positioned(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  durationTransform(videoMo.duration),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                )),
            bottom: 8,
            right: 8,
          )
        ],
      ),
    );
  }

  _buildContent() {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(videoMo.title), _buildBottomContent()],
          )),
    );
  }

  _buildBottomContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _onner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.ondemand_video, videoMo.view),
                hiSpace(width: 5),
                ...smallIconText(Icons.list_alt, videoMo.reply)
              ],
            ),
            const Icon(
              Icons.more_vert_sharp,
              color: Colors.grey,
              size: 15,
            )
          ],
        )
      ],
    );
  }

  _onner() {
    var owner = videoMo.owner;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          padding: const EdgeInsets.all(1),
          child: const Text(
            'UP',
            style: TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        hiSpace(height: 8),
        Text(
          owner.name,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        )
      ],
    );
  }
}
