import 'package:flutter/material.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/core/hi_state.dart';
import 'package:flutter_code/http/dao/home_dao.dart';
import 'package:flutter_code/model/home_mo.dart';
import 'package:flutter_code/navigator/hi_navigator.dart';
import 'package:flutter_code/page/home_top_tab_page.dart';
import 'package:flutter_code/page/video_detial_page.dart';
import 'package:flutter_code/utils/toast_util.dart';
import 'package:flutter_code/widget/hi_tab.dart';
import 'package:flutter_code/widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? jumpTabTo;

  const HomePage({Key? key, this.jumpTabTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

///HomePage的State为什么要实现AutomaticKeepAliveClientMixin来保存状态了？
///AutomaticKeepAliveClientMixin表示重新创建的Widget中的State是旧的Wiget的State，
///Home->Rank->Home,根据BiliRouteDelegate中的#1可知，Rank->Home,发现pages已经有Home了
///会直接移除旧的Home，然后创建一个新的Home加入pages，这样旧的Home中State中注册的路由页面跳转监听就没了，新的Home在
///initState中添加的路由跳转监听无法感知路由跳转的变化信息，HomePage的state加上AutomaticKeepAliveClientMixin后
///重新创建的HomePage的State是仍然是旧Home的state，so就可以感知到理由跳转的变化
class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  // var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片-手书-配音"];
  TabController? _controller;
  Widget? _currentPage;

  ///网络数据
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getObj().addListener(listener = (current, pre) {
      print("HomePage：${pre.page}");
      print("HomePage：${current.page}");
      var openPage = _currentPage = current.page;
      var oldPage = pre.page;
      if (widget == openPage || openPage is HomePage) {
        print("HomePage处于onResume");
      } else if (widget == oldPage || oldPage is HomePage) {
        print("HomePage处于onPause");
      }
    });
    _loadNetData();
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    HiNavigator.getObj().removeListener(listener);
    super.dispose();
  }

  //监听应用生命周期的变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive: //暂停
        break;
      case AppLifecycleState.resumed: //后台->前台
        if (_currentPage is! VideoDetialPage) {
          ///将状态栏修改为白色
        }
        break;
      case AppLifecycleState.paused: //前台->后台
        break;
      case AppLifecycleState.detached: //app结束时调用
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //AutomaticKeepAliveClientMixin
    return NavigatorBar(
        userOld: false,
        newColor: Colors.white,
        child: Scaffold(
          body: Column(
            children: [
              _appBar(),
              Container(
                color: Colors.white,
                child: _topTabBar(),
              ),
              Flexible(
                  child: TabBarView(
                controller: _controller,
                children: categoryList.map((tab) {
                  return HomeTopTabPage(
                    categoryName: tab.name,
                    bannerMoData: tab.name == "推荐" ? bannerList : null,
                  );
                }).toList(),
              ))
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  _topTabBar() {
    return HiTopTab(
      categoryList.map<Tab>((tab) {
        return Tab(child: Text(tab.name));
      }).toList(),
      controller: _controller,
      fontSize: 16,
      insets: 13,
      unSelectedLabelColor: Colors.black54,
    );
  }

  void _loadNetData() async {
    try {
      HomeMo homeMo = await HomeDao.get("推荐");
      print("Home=loadNetData:$homeMo");
      if (homeMo.categoryList != null) {
        _controller =
            TabController(length: homeMo.categoryList.length, vsync: this);
        setState(() {
          categoryList = homeMo.categoryList;
          bannerList = homeMo.bannerList;
        });
      }
    } on NeedLogin catch (e) {
      print(e.message);
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      print(e.message);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e.message);
    }
  }

  _appBar() {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (widget.jumpTabTo != null) {
                  widget.jumpTabTo!(3);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: const Image(
                  width: 46,
                  height: 46,
                  image: AssetImage('images/avatar.png'),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.search),
                  color: Colors.grey[200],
                ),
              ),
            )),
            const Icon(Icons.explore_outlined, color: Colors.grey),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
