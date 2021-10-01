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

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;
  const RegistrationPage({Key? key, required this.onJumpToLogin})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protectState = false;
  bool loginEnable = false;
  String userName = "";
  String password = "";
  String rePassword = "";
  String imoocId = "1342551";
  String orderId = "8918";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", widget.onJumpToLogin),
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
            LoginInput(
              title: "确认密码",
              hint: "请再次输入密码",
              onChange: (text) {
                rePassword = text;
                _checkInput();
              },
            ),
            LoginInput(
              title: "慕课网ID",
              hint: "请输入慕课网ID",
              initData: "1342551",
              onChange: (text) {
                imoocId = text;
                _checkInput();
              },
            ),
            LoginInput(
              title: "课程订单号",
              hint: "请输入课程订单号",
              initData: "8918",
              keyboardType: TextInputType.number,
              onChange: (text) {
                orderId = text;
                _checkInput();
              },
            ),
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
    bool enable = isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId);
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return LoginButton("注册", loginEnable, () {
      if (loginEnable) {
        _checkParams();
      } else {
        print('loginEnable is false');
      }
    });
  }

  void _send() async {
    try {
      var result =
          await LoginDao.registration(userName, password, imoocId, orderId);
      if (result['code'] == 0) {
        print("注册成功!!!");
        showToast("注册成功");
        HiNavigator.getObj().onJumpTo(RouteStatus.home);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId.length != 4) {
      tips = '请输入订单号的后四位';
    }
    if (tips != null) {
      print(tips);
      return;
    }
    _send();
  }
}
