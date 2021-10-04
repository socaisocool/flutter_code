import 'package:flutter/material.dart';
import 'package:flutter_code/http/dao/login_dao.dart';
import 'package:flutter_code/page/registration_page.dart';
import 'package:flutter_code/page/video_detial_page.dart';
import 'package:flutter_code/test/test_json.dart';
import 'package:flutter_code/utils/toast_util.dart';

import 'db/hi_cache.dart';
import 'http/dao/video_mo.dart';
import 'navigator/bottom_navigator.dart';
import 'navigator/hi_navigator.dart';
import 'page/login_page.dart';
import 'utils/color.dart';

void main() {
  // runApp(const MyApp());
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  final BiliRouteDelegate _biliRouteDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    ///没有加载状态的代码
    // var widget = Router(routerDelegate: _biliRouteDelegate);
    // return MaterialApp(
    //   home: widget,
    // );
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (context, snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _biliRouteDelegate)
              : const Scaffold(
                  body: Center(
                  child: CircularProgressIndicator(),
                ));
          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}

//如果没有涉及web开发，不设置泛型也可以
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  //与路由有关的状态
  List<MaterialPage> pages = [];
  VideoMo? showVideoModel;
  BiliRoutePath? path;

  BiliRouteDelegate() {
    HiNavigator.getObj()
        .registerRouteJump(RouteJumpLinstener((routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detial && args != null) {
        showVideoModel = args['videoMo'];
      }
      notifyListeners();
    }));
  }

  @override //可以通过navigatorKey.currentState获取当前路由的NavigatorState对象
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      ///#1
      ///要打开的页面已经存在，把在它之上，也就是pages中在它之后的page都清空
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时，pages之中只能保留HomePage，其他都要清除
      pages.clear();
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.detial) {
      // launch(showVideoModel!.url);//跳转外部浏览器
      page = pageWrap(VideoDetialPage(videoModel: showVideoModel!));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage(
          onJumpToRegister: () =>
              HiNavigator.getObj().onJumpTo(RouteStatus.registration)));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage(onJumpToLogin: () {
        _routeStatus = RouteStatus.login;
        notifyListeners();
      }));
    }
    //重新创建一个数组，否则pages因为没有引用改变，路由不会生效
    //管理路由堆栈
    tempPages = [...tempPages, page];

    ///通知路由发生变化
    HiNavigator.getObj().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
        //按返回按钮或者虚拟返回键会触发->onWillPop:true返回；false拦截
        child: Navigator(
          key: navigatorKey,
          pages: pages,

          ///Navigator.pop会触发这个回调，返回true，就回退成功，返回false就拦截这个操作
          onPopPage: (route, result) {
            //maybePop返回true才会触发
            if (route.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast("请先登录");
                  return false;
                }
              }
            }

            ///route.didPop这个是系统操作，由系统判断是否可以让完成移除操作，移除成功返回true，移除失败返回的false
            ///Navigator.pop触发onPopPage回调，onPopPage默认是返回route.didPop的执行结果
            ///route.didPop执行之前我们可以根据route判断是否拦截pop,要拦截直接让onPopPage返回false
            ///调用oute.didPop表示确定要移除，如果移除失败，就让onPopPage返回false，表示移除失败
            ///这里我们要自己管理Page的添加移除，所以我们就不执行route.didPop方法，而是自己控制
            ///要移除的Page在pages中的状态
            if (!route.didPop(result)) {
              ///这个方法含义不理解
              return false;
            }
            var tempPages = [...pages];
            pages.removeLast(); //移除栈顶的Page
            ///通知路由发生变化
            HiNavigator.getObj().notify(pages, tempPages);
            return true;
          },
        ), //maybePop:处于栈顶就返回false
        onWillPop: () async => await navigatorKey.currentState!.maybePop());
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    //web有关
    this.path = path;
  }

  //路由当前状态
  RouteStatus _routeStatus =
      LoginDao.getBoardingPass() != null ? RouteStatus.home : RouteStatus.login;
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (showVideoModel != null) {
      return _routeStatus = RouteStatus.detial;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.BOARDING_PASS != null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HiCache.preInit(),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: white,
            ),
            home: LoginPage(onJumpToRegister: () {}),
          );
        });
  }
}

///以下都是案例代码
void test() async {
  // TestRequest testRequest = TestRequest();
  // testRequest
  //     .add("aaaa", "bbb")
  //     .add("bbb", "333")
  //     .add("requestPrams", "3333");
  // try {
  //   var result = await HiNet.getInstance().fire(testRequest);
  //   print(result);
  // } on NeedAuth catch (e) {
  //   print(e);
  // } on NeedLogin catch (e) {
  //   print(e);
  // } on HiNetError catch (e) {
  //   print(e);
  // }

  NetTest().login();
  // NetTest().testNotice();
  // AboutJson().map2Json();
  // var modelMap = {
  //   "name": "伊零Onezero",
  //   "face":
  //       "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
  //   "fans": 0
  // };
  //
  // Owner owner = Owner.fromMap(modelMap);
  // print(owner);
}
