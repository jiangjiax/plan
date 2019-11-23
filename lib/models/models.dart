import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provide/provide.dart';
import '../models/ajax_models.dart';
import 'package:provide/provide.dart';
import 'dart:convert';

Color toColor(String s) {
  if (s == null || s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
    s = '#999999';
  }
  return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
}

class PrintLog {
  static bool debuggable = false; //是否是debug模式,true: log v 不输出.

  static void init({bool isDebug = false}) {
    debuggable = isDebug;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void v(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write((tag == null || tag.isEmpty));
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}

// 路由
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}

class SlideTopRoute extends PageRouteBuilder {
  final Widget page;
  SlideTopRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate
      )),
      child: child,
    ),
  );
}

class NoRoute extends PageRouteBuilder {
  final Widget page;
  NoRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}

class PopRoute extends PopupRoute{
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;

}

void addPrefsList(s, testList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(s, testList);

  // showPrefs(s).then((v){
  //   print(v);
  // });
}

Future showPrefsList(s) async {
  var v = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ( prefs.getStringList(s) != null ) {
    v = prefs.getStringList(s);
  }
  return v;
}

void addPrefsValue(s, testList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(s, testList);
}

Future showPrefsValue(s) async {
  var v = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ( prefs.getString(s) != null ) {
    v = prefs.getString(s);
  }
  return v;
}

void removePrefs(s) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(s);
}

// init
void initApp(context) {
  getAjax(
    "UserInformation",{}
  ).then((val){
    if (val["err"] != 0) {
      // 没登陆
      Provide.value<UserData>(context).logout();
    } else {
      showPrefsValue("login").then((v){
        if (v != "") {
          var vjson = json.decode(v);
          if (vjson["login"] == "1") {
            var pro = Provide.value<UserData>(context);
            pro.changeAll("1", vjson["avatar"], vjson["mobile"], vjson["nickname"], int.parse(vjson["heart"]));
            topTodayData(context, 0);
          }
        }
      });
    }
  });
}