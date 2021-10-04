import 'package:flutter_code/http/core/base_request.dart';

class VideoDetialRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return 'uapi/fa/detail';
  }
}
