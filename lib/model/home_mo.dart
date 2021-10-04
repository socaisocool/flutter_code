import 'dart:convert';

import 'package:flutter_code/model/video_mo.dart';
import 'package:flutter_code/utils/convert_util.dart';

class HomeMo {
  HomeMo({
    required this.bannerList,
    required this.categoryList,
    required this.videoList,
  });

  factory HomeMo.fromJson(Map<String, dynamic> jsonRes) {
    final List<BannerMo>? bannerList =
        jsonRes['bannerList'] is List ? <BannerMo>[] : null;
    if (bannerList != null) {
      for (final dynamic item in jsonRes['bannerList']!) {
        if (item != null) {
          bannerList.add(BannerMo.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CategoryMo>? categoryList =
        jsonRes['categoryList'] is List ? <CategoryMo>[] : null;
    if (categoryList != null) {
      for (final dynamic item in jsonRes['categoryList']!) {
        if (item != null) {
          categoryList
              .add(CategoryMo.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<VideoMo>? videoList =
        jsonRes['videoList'] is List ? <VideoMo>[] : null;
    if (videoList != null) {
      for (final dynamic item in jsonRes['videoList']!) {
        if (item != null) {
          videoList.add(VideoMo.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return HomeMo(
      bannerList: bannerList ?? [],
      categoryList: categoryList ?? [],
      videoList: videoList!,
    );
  }

  List<BannerMo> bannerList;
  List<CategoryMo> categoryList;
  List<VideoMo> videoList;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bannerList': bannerList,
        'categoryList': categoryList,
        'videoList': videoList,
      };
}

class BannerMo {
  BannerMo({
    required this.id,
    required this.sticky,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.cover,
    required this.createTime,
  });

  factory BannerMo.fromJson(Map<String, dynamic> jsonRes) => BannerMo(
        id: asT<String>(jsonRes['id'])!,
        sticky: asT<int>(jsonRes['sticky'])!,
        type: asT<String>(jsonRes['type'])!,
        title: asT<String>(jsonRes['title'])!,
        subtitle: asT<String>(jsonRes['subtitle'])!,
        url: asT<String>(jsonRes['url'])!,
        cover: asT<String>(jsonRes['cover'])!,
        createTime: asT<String>(jsonRes['createTime'])!,
      );

  String id;
  int sticky;
  String type;
  String title;
  String subtitle;
  String url;
  String cover;
  String createTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sticky': sticky,
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'url': url,
        'cover': cover,
        'createTime': createTime,
      };
}

class CategoryMo {
  CategoryMo({
    required this.name,
    required this.count,
  });

  factory CategoryMo.fromJson(Map<String, dynamic> jsonRes) => CategoryMo(
        name: asT<String>(jsonRes['name'])!,
        count: asT<int>(jsonRes['count'])!,
      );

  String name;
  int count;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'count': count,
      };
}
