import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code/http/core/hi_net_error.dart';
import 'package:flutter_code/http/dao/login_dao.dart';
import 'package:flutter_code/navigator/hi_navigator.dart';
import 'package:flutter_code/utils/string_util.dart';
import 'package:flutter_code/utils/toast_util.dart';
import 'package:flutter_code/widget/appbar.dart';
import 'package:flutter_code/widget/login_button.dart';
import 'package:flutter_code/widget/login_effect.dart';
import 'package:flutter_code/widget/login_input.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onJumpToRegister;
  const LoginPage({Key? key, required this.onJumpToRegister}) : super(key: key);

  @override
  _LoginPagePageState createState() => _LoginPagePageState();
}

class _LoginPagePageState extends State<LoginPage> {
  bool protectState = false;
  bool loginEnable = false;
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("登录", "注册", widget.onJumpToRegister),
      body: Container(
        child: ListView(
          //自适应键盘谈起，防止遮挡
          children: [
            LoginEffect(protect: protectState),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChange: (text) {
                userName = text;
                _checkInput();
              },
            ),
            LoginInput(
                title: "密码",
                hint: "请输入密码",
                obscureText: true,
                onChange: (text) {
                  password = text;
                  _checkInput();
                },
                focusChanged: (isFocus) {
                  setState(() {
                    protectState = isFocus;
                  });
                }),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: _loginButton(),
            )
          ],
        ),
      ),
    );
  }

  void _checkInput() {
    bool enable = isNotEmpty(userName) && isNotEmpty(password);
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return LoginButton("登录", loginEnable, () {
      if (loginEnable) {
        _send();
      } else {
        print('loginEnable is false');
      }
    });
  }

  void _send() async {
    try {
      var result = await LoginDao.login(userName, password);
      if (result['code'] == 0) {
        print("登录成功!!!");
        showToast("登录成功!!!");
        HiNavigator.getObj().onJumpTo(RouteStatus.home);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on HiNetError catch (e) {
      print(e);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
