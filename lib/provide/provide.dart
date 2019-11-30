import 'package:flutter/material.dart';
import 'package:myplan/config/config.dart';
import 'package:myplan/models/models.dart';
import '../models/ajax_models.dart';

// 任务列表
class ItemList extends ChangeNotifier {
  List items = [
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
  List plays = [];
  
  // 今日任务显示数据
  var itemTotal = 0; // 任务数
  var itemComplete = 0; // 完成任务数
  double itemPercentage = 0.0; // 完成任务数百分比
  var heartComplete = 0; // 清单获得心心数

  // 娱乐/休息显示数据
  var playTotal = 0; // 任务数
  var playComplete = 0; // 完成任务数
  double playPercentage = 0.0; // 完成任务数百分比
  var playheartComplete = 0; // 清单消费心心数

  List myDel = []; // 删除清单

  void changeData(cate, itemTotals, itemCompletes, itemPercentages, heartCompletes) {
    switch(cate) {
      case "0":
        // 今日
        itemTotal = itemTotals;
        itemComplete = itemCompletes;
        itemPercentage = itemPercentages;
        heartComplete = heartCompletes;
        break;
      case "1":
        // 娱乐
        playTotal = itemTotals;
        playComplete = itemCompletes;
        playPercentage = itemPercentages;
        playheartComplete = heartCompletes;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeList(v, cate) {
    switch(cate) {
      case "0":
        // 今日
        items = v;
        break;
      case "1":
        // 娱乐
        plays = v;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void add(v, cate) {
    switch(cate) {
      case "0":
        // 今日
        items.add(v);
        break;
      case "1":
        // 娱乐
        plays.add(v);
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void del(index, cate) {
    switch(cate) {
      case "0":
        // 今日
        var id = items[index]["id"];
        if (id != "") {
          myDel.add(id);
        }
        items.removeAt(index);
        break;
      case "1":
        // 娱乐
        var id = plays[index]["id"];
        if (id != "") {
          myDel.add(id);
        }
        plays.removeAt(index);
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeComplete(index, complete, cate) {
    switch(cate) {
      case "0":
        // 今日
        items[index]["complete"] = complete;
        break;
      case "1":
        // 娱乐
        plays[index]["complete"] = complete;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeIm(index, im, cate) {
    switch(cate) {
      case "0":
        // 今日
        items[index]["im"] = im;
        break;
      case "1":
        // 娱乐
        plays[index]["im"] = im;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeTitle(index, title, cate) {
    switch(cate) {
      case "0":
        // 今日
        items[index]["title"] = title;
        break;
      case "1":
        // 娱乐
        plays[index]["title"] = title;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeHeart(index, heart, cate) {
    switch(cate) {
      case "0":
        // 今日
        items[index]["heart"] = heart;
        break;
      case "1":
        // 娱乐
        plays[index]["heart"] = heart;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void changeNote(index, note, cate) {
    switch(cate) {
      case "0":
        // 今日
        items[index]["note"] = note;
        break;
      case "1":
        // 娱乐
        plays[index]["note"] = note;
        break;
      case "2":
        // 明日
        break;
      default:
        break;
    }
    notifyListeners();
  }
}

// 登陆注册同步数据
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
    // heart = 0;
    notifyListeners();
  }
}

// log
class Log extends ChangeNotifier {
  String log = "";
  String logMonth = "";
  String logYear = "";

  void add(v) {
    log = v;
    notifyListeners();
  }

  void addMonth(v) {
    logMonth = v;
    notifyListeners();
  }

  void addYear(v) {
    logYear = v;
    notifyListeners();
  }
}

// 颜色数据
class ColorData with ChangeNotifier {
  Color work = Colors.blue;
  Color play = Colors.red;
  int pagecate = 1;

  void refresh(v) {
    myColor = v;
    notifyListeners();
  }

  void changeCate(v) {
    pagecate = v;
    notifyListeners();
  }

  void changeWork(v) {
    work = v;
    myColor = v;
    notifyListeners();
  }

  void changePlay(v) {
    play = v;
    myColor = v;
    notifyListeners();
  }
}

// 番茄时钟时间
class Tomato {
  Tomato(this.text, this.selectId, this.time);
  String text; 
  int selectId;
  Duration time; 
}

class TomatoTimes extends ChangeNotifier {
  List<Tomato> tomatoChoiceChip = [
    Tomato("10分钟", 0, Duration(minutes: 10)),
    Tomato("25分钟", 1, Duration(minutes: 25)),
    Tomato("35分钟", 2, Duration(minutes: 35)),
    Tomato("45分钟", 3, Duration(minutes: 45)),
    Tomato("60分钟", 4, Duration(minutes: 60)),
    Tomato("自定义", 5, Duration(minutes: 25)),
  ];

  void changeCustom(time) {
    tomatoChoiceChip[5].text = time.toString() + "分钟";
    tomatoChoiceChip[5].time = Duration(minutes: time);
    notifyListeners();
  }

  void changeCustomRe() {
    tomatoChoiceChip[5].text = "自定义";
    tomatoChoiceChip[5].time = Duration(minutes: 25);
    notifyListeners();
  }
}