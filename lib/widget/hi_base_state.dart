import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/core/hi_state.dart';
import 'package:flutter_code/utils/toast_util.dart';

///通用底层带分页和刷新的页面框架
///M为Dao返回的数据模型，L为列表数据模型，T为具体Widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  int pageIndex = 1;
  List<L> dataList = [];
  bool loading = false;
  final ScrollController controller = ScrollController();
  get contentChild;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      var dis =
          controller.position.maxScrollExtent - controller.position.pixels;
      if (dis < 300 &&
          !loading &&

          ///当列表高度不足满屏高度时不加载更多
          controller.position.maxScrollExtent != 0) {
        loadNetData(loadMore: true);
      }
    });
    loadNetData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
          child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: contentChild,
      )),
      onRefresh: loadNetData,
      color: Colors.deepOrangeAccent,
      backgroundColor: Colors.white,
    );
  }

  ///获取对应页码的数据
  Future<M> getData(int pageIndex);

  ///从MO中解析出list数据
  List<L> parseList(M result);

  Future loadNetData({loadMore = false}) async {
    if (loading) {
      print("上次加载还没完成.....");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    try {
      int currentPageIndex = pageIndex += loadMore ? 1 : 0;
      M result = await getData(currentPageIndex);
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).isNotEmpty) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        loading = false;
      });
    } on NeedLogin catch (e) {
      print(e.message);
      showWarnToast(e.message);
      loading = false;
    } on NeedAuth catch (e) {
      print(e.message);
      showWarnToast(e.message);
      loading = false;
    } on HiNetError catch (e) {
      print(e.message);
      loading = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
