import 'dart:io';

import 'package:flutter_code/http/core/base_request.dart' as Base;
import 'package:flutter_code/http/core/hi_net_adapter.dart';
import 'package:http/http.dart';

import 'hi_net_error.dart';

class HttpAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(Base.BaseRequest request) async {
    Map<String, String>? headerPrams = <String, String>{};
    late Response response;
    HttpException? error;
    Uri? uri;
    String pathStr =
        request.path().startsWith("/") ? request.path() : "/${request.path()}";
    if (request.useHttps) {
      uri = Uri.https(request.authority(), pathStr, request.params);
    } else {
      uri = Uri.http(request.authority(), pathStr, request.params);
    }
    request.headers.forEach((key, value) {
      headerPrams[key] = value.toString();
    });
    try {
      if (request.httpMethod() == Base.HttpMethod.GET) {
        response = await get(uri);
      } else if (request.httpMethod() == Base.HttpMethod.POST) {
        response = await post(uri, headers: headerPrams);
      } else if (request.httpMethod() == Base.HttpMethod.DELETE) {
        response = await delete(uri, headers: headerPrams);
      }
    } on HttpException catch (e) {
      error = e;
    }
    if (error != null) {
      throw HiNetError(response.statusCode, error.toString());
    }
    return buildRes(response, request);
  }

  buildRes(Response response, request) {
    return HiNetResponse(
        data: response.body,
        request: request,
        statusMessage: response.toString(),
        statusCode: response.statusCode,
        extra: response);
  }
}
