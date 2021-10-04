import 'package:flutter_code/http/core/hi_net.dart';
import 'package:flutter_code/http/request/rank_request.dart';
import 'package:flutter_code/model/rank_mo.dart';

class RankDao {
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async {
    RankRequest request = RankRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);

    ///不加await返回的就是Future对象
    var result = await HiNet.getInstance().fire(request);
    return RankMo.fromJson(result['data']);
  }
}
