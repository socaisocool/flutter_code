import 'package:flutter/cupertino.dart';

class HomeTopTabPage extends StatefulWidget {
  final String tabName;
  const HomeTopTabPage({Key? key, required this.tabName}) : super(key: key);

  @override
  _HomeTopTabPageState createState() => _HomeTopTabPageState();
}

class _HomeTopTabPageState extends State<HomeTopTabPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(widget.tabName),
      ),
    );
  }
}
