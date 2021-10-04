import 'dart:convert';
import 'dart:developer';

import 'package:flutter_code/http/dao/video_mo.dart';

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

class RankMo {
  RankMo({
    this.total,
    this.list,
  });

  factory RankMo.fromJson(Map<String, dynamic> jsonRes) {
    final List<VideoMo>? list = jsonRes['list'] is List ? <VideoMo>[] : null;
    if (list != null) {
      for (final dynamic item in jsonRes['list']!) {
        if (item != null) {
          tryCatch(() {
            list.add(VideoMo.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return RankMo(
      total: asT<int?>(jsonRes['total']),
      list: list,
    );
  }

  int? total;
  List<VideoMo>? list;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'list': list,
      };
}

class Owner {
  Owner({
    this.name,
    this.face,
    this.fans,
  });

  factory Owner.fromJson(Map<String, dynamic> jsonRes) => Owner(
        name: asT<String?>(jsonRes['name']),
        face: asT<String?>(jsonRes['face']),
        fans: asT<int?>(jsonRes['fans']),
      );

  String? name;
  String? face;
  int? fans;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'face': face,
        'fans': fans,
      };

  Owner copy() {
    return Owner(
      name: name,
      face: face,
      fans: fans,
    );
  }
}
