// ignore_for_file: constant_identifier_names

import 'package:flutter_code/db/hi_cache.dart';
import 'package:flutter_code/http/core/base_request.dart';
import 'package:flutter_code/http/core/hi_net.dart';
import 'package:flutter_code/http/request/login_request.dart';
import 'package:flutter_code/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass"; //登录令牌

  static login(String userName, String password) {
    return _send(userName, password, imoocId: "", orderId: "");
  }

  static registration(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password, {imoocId, orderId}) async {
    BaseRequest? request;
    if (imoocId != "" && orderId != "") {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request
        .add("userName", userName)
        .add("password", password)
        .add("imoocId", imoocId)
        .add("orderId", orderId);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }

    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
