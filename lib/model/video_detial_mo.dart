import 'dart:convert';
import 'dart:developer';

import 'package:flutter_code/model/video_mo.dart';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  // ignore: prefer_function_declarations_over_variables
  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class VideoDetialMo {
  VideoDetialMo({
    this.isFavorite,
    this.isLike,
    this.videoInfo,
    this.videoList,
  });

  factory VideoDetialMo.fromJson(Map<String, dynamic> jsonRes) {
    final List<VideoMo>? videoList =
        jsonRes['videoList'] is List ? <VideoMo>[] : null;
    if (videoList != null) {
      for (final dynamic item in jsonRes['videoList']!) {
        if (item != null) {
          tryCatch(() {
            videoList.add(VideoMo.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return VideoDetialMo(
      isFavorite: asT<bool?>(jsonRes['isFavorite']),
      isLike: asT<bool?>(jsonRes['isLike']),
      videoInfo: jsonRes['videoInfo'] == null
          ? null
          : VideoMo.fromJson(asT<Map<String, dynamic>>(jsonRes['videoInfo'])!),
      videoList: videoList,
    );
  }

  bool? isFavorite;
  bool? isLike;
  VideoMo? videoInfo;
  List<VideoMo>? videoList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isFavorite': isFavorite,
        'isLike': isLike,
        'videoInfo': videoInfo,
        'videoList': videoList,
      };
}
