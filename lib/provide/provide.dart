import 'package:flutter/material.dart';
import '../models/ajax_models.dart';

// 任务列表
class ItemList extends ChangeNotifier {
  List<dynamic> items = [
    // {
    //   "id": "",
    //   "title": "title",
    //   "note": "note",
    //   "heart": 0,
    //   "cate": "0",
    //   "im": "0",
    //   "complete": "0",
    //   "syn": "1", // 1 已同步
    // },
  ];
  
  // 清单完成任务数百分比、任务数、完成任务数、清单获得心心数
  var itemTotal = 0; // 任务数
  var itemComplete = 0; // 完成任务数
  double itemPercentage = 0.0; // 完成任务数百分比
  var heartComplete = 0; // 清单获得心心数

  void changeData(itemTotals, itemCompletes, itemPercentages, heartCompletes) {
    itemTotal = itemTotals;
    itemComplete = itemCompletes;
    itemPercentage = itemPercentages;
    heartComplete = heartCompletes;
    notifyListeners();
  }

  void changeList(v) {
    items = v;
    notifyListeners();
  }

  // void add(text, heart, note) {

  //   notifyListeners();
  // }

  // void del(context, index) {
  //   hakunamatata.removeAt(index);
  //   // BotToast.showText(
  //   //   text:"删除成功",
  //   //   onlyOne: true,
  //   //   clickClose: true,
  //   // ); 
  //   Navigator.of(context).pop();
  //   notifyListeners();
  // }

  void changeComplete(index, complete) {
    items[index]["complete"] = complete;
    notifyListeners();
  }

  // void changeTitle(index, text) {
  //   hakunamatata[index]["text"] = text;
  //   notifyListeners();
  // }

  // void changeCollect(index, collect) {
  //   hakunamatata[index]["collect"] = collect;
  //   notifyListeners();
  // }

  // void changeHeart(index, heart) {
  //   hakunamatata[index]["heart"] = heart;
  //   // BotToast.showText(
  //   //   text:"💖 设置成功",
  //   //   onlyOne: true,
  //   //   clickClose: true,
  //   // ); 
  //   notifyListeners();
  // }

  // void changeNote(index, note) {
  //   hakunamatata[index]["note"] = note;
  //   notifyListeners();
  // }
}

// 全局数据
class GlobalData with ChangeNotifier {
  bool loginLoading = false;  // 登陆loading
  bool registerLoading = false;  // 注册loading
  String syn = "当前数据已同步"; // 同步

  void changeLoginLoading(v) {
    loginLoading = v;
    notifyListeners();
  }

  void changeRegisterLoading(v) {
    registerLoading = v;
    notifyListeners();
  }

  void changeSyn(v) {
    syn = v;
    notifyListeners();
  }
}

// 用户信息
class UserData with ChangeNotifier {
  var login = "0"; // 是否登陆
  var avatar = "";
  var mobile = "请前往登陆或注册";
  var nickname = "当前未登陆";
  var heart = 0;

  void changeLogin(v) {
    login = v;
    notifyListeners();
  }

  void changeAvatar(v) {
    avatar = v;
    notifyListeners();
  }

  void changeMobile(v) {
    mobile = v;
    notifyListeners();
  }
  
  void changeNickname(v) {
    nickname = v;
    notifyListeners();
  }

  void changeHeart(v) {
    heart = v;
    notifyListeners();
  }

  void changeAll(l, a, m , n, h) {
    login = l;
    avatar = a;
    mobile = m;
    nickname = n;
    heart = h;
    notifyListeners();
  }

  void logout() {
    login = "0";
    avatar = "";
    mobile = "请前往登陆或注册";
    nickname = "当前未登陆";
    heart = 0;
    notifyListeners();
  }
}