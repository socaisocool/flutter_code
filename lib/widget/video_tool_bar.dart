import 'package:flutter/material.dart';
import 'package:flutter_code/model/video_detial_mo.dart';
import 'package:flutter_code/model/video_mo.dart';
import 'package:flutter_code/utils/color.dart';
import 'package:flutter_code/utils/format_util.dart';
import 'package:flutter_code/utils/view_util.dart';

class VideoToolBar extends StatelessWidget {
  final VideoDetialMo? detialMo;
  final VideoMo videoMo;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {Key? key,
      required this.detialMo,
      required this.videoMo,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        border: borderLiner(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconText(Icons.thumb_up_alt, videoMo.like,
              onClick: onLike, tint: detialMo?.isLike ?? false),
          _buildIconText(Icons.thumb_down_alt, '不喜欢', onClick: onUnLike),
          _buildIconText(Icons.monetization_on, videoMo.coin, onClick: onCoin),
          _buildIconText(Icons.grade_rounded, videoMo.favorite,
              onClick: onFavorite, tint: detialMo?.isFavorite ?? false),
          _buildIconText(Icons.share_rounded, videoMo.share, onClick: onShare),
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      text = countFormat(text);
    }
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
