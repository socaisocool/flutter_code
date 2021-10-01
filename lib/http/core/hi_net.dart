import 'package:flutter_code/http/core/base_request.dart';
import 'package:flutter_code/http/core/hi_net_adapter.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';

import 'dio_adapter.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    // var response = await send(request);
    // var result = response['data'];
    // return Future.value(result);

    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //其他异常
      response = null;
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(request);
    var statusCode = response?.statusCode;
    statusCode ??= -1;
    switch (statusCode) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(statusCode, result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    printLog('method:${request.httpMethod()}');
    // request.addHeader("token", "123");
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 0, "message": "success"}
    // });
    ///使用Mock发送请求
    HiNetAdapter adapter = DioAdapter(); //HttpAdapter(); //MockAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
