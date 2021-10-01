// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_code/page/login_page.dart';
import 'package:flutter_code/page/registration_page.dart';
import 'package:flutter_code/page/video_detial_page.dart';

import 'bottom_navigator.dart';

typedef RouteChangeLisntener(RouteStateInfo current, RouteStateInfo? pre);

///创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int index = 0; index < pages.length; index++) {
    MaterialPage page = pages[index];
    if (getStatus(page) == routeStatus) {
      return index;
    }
  }
  return -1;
}

///自定义路由封装，路由哦状态
enum RouteStatus { login, registration, home, detial, unknow }

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetialPage) {
    return RouteStatus.detial;
  } else {
    return RouteStatus.unknow;
  }
}

//路由信息
class RouteStateInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStateInfo(this.routeStatus, this.page);
}

///监听路由页面跳转，感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  HiNavigator._();
  static HiNavigator? _instance;
  static HiNavigator getObj() {
    return _instance ??= HiNavigator._();
  }

  ///当前处于栈顶的Page信息
  RouteStateInfo? _oldTop;

  ///注册路由跳转信息
  void registerRouteJump(RouteJumpLinstener routeJumpLinstener) {
    _routeJump = routeJumpLinstener;
  }

  RouteJumpLinstener? _routeJump;

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  final List<RouteChangeLisntener> _listeners = [];

  ///监听路由页面跳转
  void addListener(RouteChangeLisntener lisntener) {
    if (!_listeners.contains(lisntener)) {
      _listeners.add(lisntener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeLisntener lisntener) {
    _listeners.remove(lisntener);
  }

  ///通知路由页面变化   当前堆栈信息   之前的堆栈信息
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;

    ///路由堆栈变化了，取出即将需要打开的处于栈顶的Page
    var topPage =
        RouteStateInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(topPage);
  }

  void _notify(RouteStateInfo topPage) {
    if (topPage.page is BottomNavigator && _bottomTab != null) {
      //如果打开的是首页，则明确到首页具体的tab
      topPage = _bottomTab!;
    }
    print('hi_navigator:newTop:${topPage.page}');
    print('hi_navigator:oldTop:${_oldTop?.page}');
    for (var listener in _listeners) {
      listener(topPage, _oldTop);
    }
    _oldTop = topPage;
  }

  //首页底部的Tab
  RouteStateInfo? _bottomTab;

  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStateInfo(RouteStatus.home, page);
    _notify(_bottomTab!); //要扩展对底部导航的支持
  }
}

///这个抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

///定义路由跳转逻辑要实现的功能
class RouteJumpLinstener {
  OnJumpTo onJumpTo;

  RouteJumpLinstener(this.onJumpTo);
}
