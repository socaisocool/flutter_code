import 'package:flutter/material.dart';
import 'package:flutter_code/utils/color.dart';

class LoginInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final String? initData;
  final ValueChanged<String>? onChange;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch; //下划线
  final bool obscureText; //输入模式
  final TextInputType? keyboardType; //输入框类型
  TextEditingController? controller;

  LoginInput({
    Key? key,
    this.title,
    this.hint,
    this.onChange,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
    this.initData,
    this.controller,
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller ??= TextEditingController(text: widget.initData ?? "");
    _focusNode.addListener(() {
      bool focusState = _focusNode.hasFocus;
      print("has focus:$focusState");
      if (widget.focusChanged != null) {
        widget.focusChanged!(focusState);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: const Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: TextField(
            focusNode: _focusNode,
            onChanged: widget.onChange,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            autofocus: !widget.obscureText,
            cursorColor: primary,
            controller: widget.controller,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey))));
  }
}
