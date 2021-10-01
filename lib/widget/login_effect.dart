import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({Key? key, required this.protect}) : super(key: key);

  @override
  _LoginEffectState createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _image(widget.protect),
      ),
    );
  }

  List<Widget> _image(bool protect) {
    var headLeft =
        !protect ? 'images/head_left_protect.png' : 'images/head_left.png';
    var headRight =
        !protect ? 'images/head_right_protect.png' : 'images/head_right.png';
    return [
      Image(
        image: AssetImage(headLeft),
        height: 90,
      ),
      const Image(
        image: AssetImage("images/logo.png"),
        height: 48,
      ),
      Image(
        image: AssetImage(headRight),
        height: 90,
      )
    ];
  }
}
