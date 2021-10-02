import 'package:flutter_code/http/core/hi_net.dart';
import 'package:flutter_code/http/request/home_request.dart';
import 'package:flutter_code/model/home_mo.dart';

class HomeDao {
  static get(String categoryName, {int pageIndex = 1, pageSize = 10}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);

    ///不加await返回的就是Future对象
    var result = await HiNet.getInstance().fire(request);
    return HomeMo.fromJson(result['data']);
  }
}
