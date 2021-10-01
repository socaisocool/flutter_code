import 'package:flutter_code/http/core/base_request.dart';
import 'package:flutter_code/http/core/hi_net_adapter.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future<HiNetResponse<T>>.delayed(const Duration(milliseconds: 1000),
        () {
      return HiNetResponse(
          data: {"code": 0, "message": "success"} as T, statusCode: 200);
    });
  }
}
