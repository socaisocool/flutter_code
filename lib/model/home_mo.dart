import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

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

class VideoMo {
  VideoMo({
    required this.id,
    required this.vid,
    required this.title,
    required this.tname,
    required this.url,
    required this.cover,
    required this.pubdate,
    required this.desc,
    required this.view,
    required this.duration,
    required this.owner,
    required this.reply,
    required this.favorite,
    required this.like,
    required this.coin,
    required this.share,
    required this.createTime,
    required this.size,
  });

  factory VideoMo.fromJson(Map<String, dynamic> jsonRes) => VideoMo(
        id: asT<String>(jsonRes['id'])!,
        vid: asT<String>(jsonRes['vid'])!,
        title: asT<String>(jsonRes['title'])!,
        tname: asT<String>(jsonRes['tname'])!,
        url: asT<String>(jsonRes['url'])!,
        cover: asT<String>(jsonRes['cover'])!,
        pubdate: asT<int>(jsonRes['pubdate'])!,
        desc: asT<String>(jsonRes['desc'])!,
        view: asT<int>(jsonRes['view'])!,
        duration: asT<int>(jsonRes['duration'])!,
        owner: Owner.fromJson(asT<Map<String, dynamic>>(jsonRes['owner'])!),
        reply: asT<int>(jsonRes['reply'])!,
        favorite: asT<int>(jsonRes['favorite'])!,
        like: asT<int>(jsonRes['like'])!,
        coin: asT<int>(jsonRes['coin'])!,
        share: asT<int>(jsonRes['share'])!,
        createTime: asT<String>(jsonRes['createTime'])!,
        size: asT<int>(jsonRes['size'])!,
      );

  String id;
  String vid;
  String title;
  String tname;
  String url;
  String cover;
  int pubdate;
  String desc;
  int view;
  int duration;
  Owner owner;
  int reply;
  int favorite;
  int like;
  int coin;
  int share;
  String createTime;
  int size;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'vid': vid,
        'title': title,
        'tname': tname,
        'url': url,
        'cover': cover,
        'pubdate': pubdate,
        'desc': desc,
        'view': view,
        'duration': duration,
        'owner': owner,
        'reply': reply,
        'favorite': favorite,
        'like': like,
        'coin': coin,
        'share': share,
        'createTime': createTime,
        'size': size,
      };
}

class Owner {
  Owner({
    required this.name,
    required this.face,
    required this.fans,
  });

  factory Owner.fromJson(Map<String, dynamic> jsonRes) => Owner(
        name: asT<String>(jsonRes['name'])!,
        face: asT<String>(jsonRes['face'])!,
        fans: asT<int>(jsonRes['fans'])!,
      );

  String name;
  String face;
  int fans;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'face': face,
        'fans': fans,
      };
}
