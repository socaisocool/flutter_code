import 'package:flutter/material.dart';
import 'package:flutter_code/page/rank_tab_page.dart';
import 'package:flutter_code/utils/view_util.dart';
import 'package:flutter_code/widget/hi_tab.dart';
import 'package:flutter_code/widget/navigation_bar.dart';

class RankPage extends StatefulWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<RankPage> with TickerProviderStateMixin {
  TabController? _tabController;
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TABS.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavgationBar(),
          _buildTabView(),
        ],
      ),
    );
  }

  _buildNavgationBar() {
    return NavigatorBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
      ),
      decoration: bottomBoxShadow(),
    );
  }

  HiTopTab _tabBar() {
    return HiTopTab(
      TABS.map<Tab>((tab) {
        return Tab(child: Text(tab['name']!));
      }).toList(),
      controller: _tabController,
      fontSize: 16,
      insets: 13,
      unSelectedLabelColor: Colors.black54,
    );
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
      controller: _tabController,
      children: TABS.map((tab) {
        return Container(
          padding: const EdgeInsets.only(top: 8),
          child: RankTabPage(
            sort: tab['key'] ?? "like",
          ),
          color: Colors.white,
        );
      }).toList(),
    ));
  }
}
