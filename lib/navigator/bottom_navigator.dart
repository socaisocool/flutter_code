import 'package:flutter/material.dart';
import 'package:flutter_code/navigator/hi_navigator.dart';
import 'package:flutter_code/page/favorite_page.dart';
import 'package:flutter_code/page/home_page.dart';
import 'package:flutter_code/page/profile_page.dart';
import 'package:flutter_code/page/rank_page.dart';
import 'package:flutter_code/utils/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _pageController =
      PageController(initialPage: initialPage);
  late List<Widget> _pages;
  bool hasBuild = false;
  @override
  Widget build(BuildContext context) {
    _pages = const [
      HomePage(),
      RankPage(),
      FavoritePage(),
      ProfilePage(),
    ];
    if (!hasBuild) {
      //页面第一次打开时，通知打开的是哪个tab
      HiNavigator.getObj().onBottomTabChange(initialPage, _pages[initialPage]);
      hasBuild = true;
    }

    return Scaffold(
      body: PageView(
          controller: _pageController,
          // physics: const NeverScrollableScrollPhysics(),
          children: _pages,
          onPageChanged: (pageSelectIndex) =>
              _onTabJumpTo(pageSelectIndex, pageChange: true)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (selectIndex) => _onTabJumpTo(selectIndex),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.person, 3),
        ],
      ),
    );
  }

  void _onTabJumpTo(int tabIndex, {pageChange = false}) {
    ///#1
    if (!pageChange) {
      _pageController.jumpToPage(tabIndex);
      _currentIndex = tabIndex;
    } else {
      ///为什么放在#1会重复显示两次导航信息，这里却不会
      HiNavigator.getObj().onBottomTabChange(tabIndex, _pages[tabIndex]);
      setState(() {
        _currentIndex = tabIndex;
      });
    }
  }

  _bottomItem(String tabTitle, IconData icon, int tabIndex) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: tabTitle);
  }
}
