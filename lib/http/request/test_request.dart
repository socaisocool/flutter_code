import 'package:flutter_code/http/core/base_request.dart';

class TestRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String path() {
    return "uapi/test/test";
  }

  @override
  bool needLogin() {
    return false;
  }
}
