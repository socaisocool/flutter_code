import 'dart:convert';

import 'package:flutter_code/http/core/hi_net.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/dao/login_dao.dart';
import 'package:flutter_code/http/request/notice_request.dart';

class AboutJson {
  Map<String, dynamic> json2Map() {
    const jsonString =
        "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
    Map<String, dynamic> map = jsonDecode(jsonString);
    print('name:${map['name']}');
    print('url:${map['url']}');
    return map;
  }

  map2Json() {
    var map = json2Map();
    var json = jsonEncode(map);
    print(json);
  }
}

class NetTest {
  void register() async {
    var result = await LoginDao.registration(
        "fasfasf3141", "Abc123456", "1342551", "8918");
    print(result);
  }

  void login() async {
    var result = await LoginDao.login("fasfasf3141", "Abc123456");
    print(result);
  }

  void testNotice() async {
    NoticeRequest noticeRequest = NoticeRequest();
    // noticeRequest.add("pageIndex", "1").add("pageSize", "10");
    try {
      var result = await HiNet.getInstance().fire(noticeRequest);
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    }
  }
}
