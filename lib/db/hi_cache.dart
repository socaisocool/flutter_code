import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  static HiCache? _instance;

  SharedPreferences? prefs;

  HiCache._() {
    init();
  }

  ///初始化是异步的，可以结合FutureBuilder使用，防止未初始化完毕调用报空指针
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._();
      _instance?._pre(prefs);
    }
    return _instance!;
  }

  static HiCache getInstance() {
    _instance ??= HiCache._();
    return _instance!;
  }

  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  ///这个版本中，这里定义的是一个方法，而不是一个命名构造函数
  HiCache? _pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setStringList(String key, List<String> strs) {
    prefs?.setStringList(key, strs);
  }

  T get<T>(String key) {
    return prefs?.get(key) as T;
  }
}
