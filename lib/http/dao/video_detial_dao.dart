import 'package:flutter_code/http/core/hi_net.dart';
import 'package:flutter_code/http/request/video_detial_request.dart';
import 'package:flutter_code/model/video_detial_mo.dart';

class VideoDetialDao {
  static get(String vidId) async {
    VideoDetialRequest request = VideoDetialRequest();
    request.pathParams = vidId;

    ///不加await返回的就是Future对象
    var result = await HiNet.getInstance().fire(request);
    return VideoDetialMo.fromJson(result['data']);
  }
}
