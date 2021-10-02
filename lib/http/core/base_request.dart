import 'package:flutter_code/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

abstract class BaseRequest {
  var pathParams;
  var useHttps = true;
  Map<String, String> params = {};
  Map<String, dynamic> headers = {
    'course-flag': 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa'
  };

  String authority() {
    //域名
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  String path();

  bool needLogin();

  String url() {
    Uri uri;
    var pathStr = path();
    if (needLogin()) {
      print("登录令牌:${LoginDao.getBoardingPass() ?? "未找到登录令牌s"}");
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass() ?? "");
    }
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }

    String urlStr = uri.toString();
    print('url:$urlStr');
    return urlStr;
  }

  //添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  //添加参数
  BaseRequest addHeader(String k, Object v) {
    headers[k] = v.toString();
    return this;
  }
}
