import 'package:flutter/material.dart';
import 'package:flutter_code/navigator/hi_navigator.dart';
import 'package:flutter_code/page/home_top_tab_page.dart';
import 'package:flutter_code/utils/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

///HomePage的State为什么要实现AutomaticKeepAliveClientMixin来保存状态了？
///AutomaticKeepAliveClientMixin表示重新创建的Widget中的State是旧的Wiget的State，
///Home->Rank->Home,根据BiliRouteDelegate中的#1可知，Rank->Home,发现pages已经有Home了
///会直接移除旧的Home，然后创建一个新的Home加入pages，这样旧的Home中State中注册的路由页面跳转监听就没了，新的Home在
///initState中添加的路由跳转监听无法感知路由跳转的变化信息，HomePage的state加上AutomaticKeepAliveClientMixin后
///重新创建的HomePage的State是仍然是旧Home的state，so就可以感知到理由跳转的变化
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片-手书-配音"];
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    HiNavigator.getObj().addListener(listener = (current, pre) {
      print("HomePage：${pre.page}");
      print("HomePage：${current.page}");
      var openPage = current.page;
      var oldPage = pre.page;
      if (widget == openPage || openPage is HomePage) {
        print("HomePage处于onResume");
      } else if (widget == oldPage || oldPage is HomePage) {
        print("HomePage处于onPause");
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getObj().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //AutomaticKeepAliveClientMixin
    ImageCache();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: _topTabBar(),
            ),
            Flexible(
                child: TabBarView(
              controller: _controller,
              children: tabs.map((tab) {
                return HomeTopTabPage(
                  tabName: tab,
                );
              }).toList(),
            ))
            // const Text('首页'),
            // MaterialButton(
            //   onPressed: () => HiNavigator.getObj().onJumpTo(RouteStatus.detial,
            //       args: {'videoMo': VideoModel(1234)}),
            //   child: const Text('详情'),
            // )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _topTabBar() {
    return TabBar(
      tabs: tabs.map<Tab>((tabText) {
        return Tab(child: Text(tabText));
      }).toList(),
      isScrollable: true,
      labelColor: Colors.black,
      indicator: const UnderlineIndicator(
          strokeCap: StrokeCap.round,
          insets: EdgeInsets.only(left: 15, right: 15),
          borderSide: BorderSide(color: primary, width: 3)),
      controller: _controller,
    );
  }
}
