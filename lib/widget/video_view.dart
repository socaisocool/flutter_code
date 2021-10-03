import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code/utils/color.dart';
import 'package:flutter_code/utils/view_util.dart';
import 'package:flutter_code/widget/hi_video_controls.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String videoUrl; //视频地址
  final String cover; //封面
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget? overlayUI;

  const VideoView(
      {Key? key,
      required this.videoUrl,
      this.cover = "",
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUI})
      : super(key: key); //视频比例
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _playerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
        videoPlayerController: _playerController!,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        aspectRatio: widget.aspectRatio,
        allowMuting: false, //是否静音播放
        allowPlaybackSpeedChanging: true, //是否显示播放速度选择入口
        placeholder: _getCover(),
        materialProgressColors: _getProgressColors(),
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,

          ///视频底部比较浅，控制器显示不清晰，让底部存在渐变以突出控制器
          bottomGradient: blackLinearGradient(),
          overlayUI: widget.overlayUI,
        ));
    _chewieController?.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController?.removeListener(_fullScreenListener);
    _playerController?.dispose();
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: width / (widget.aspectRatio),
      child: Chewie(controller: _chewieController!),
      color: Colors.grey,
    );
  }

  //设置进度条的颜色样式
  _getProgressColors() => ChewieProgressColors(
      playedColor: primary, //播放状态下的颜色
      handleColor: primary, //拖动状态下的颜色
      backgroundColor: Colors.grey, //背景色
      bufferedColor: primary[50]!); //缓冲条的颜色

  //显示默认的封面
  _getCover() => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(
          DeviceOrientation.portraitUp); //切换到竖直模式
    } else {
      OrientationPlugin.forceOrientation(
          DeviceOrientation.landscapeLeft); //切换到横屏模式
    }
  }
}
