import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:myplan/models/models.dart';
import 'dart:async';
import '../provide/provide.dart';
import '../widget/index.dart';
import './models.dart';
import 'package:provide/provide.dart';

Dio dio =  Dio();
var http = "http://ismyplan.cn/";

Future postAjax(String url, Map<String, String> con) async {
  try{    
    Options options = new Options(
      headers: dio.options.headers['Cookie']
    );

    Response response;
    response = await Dio().post(http + url, queryParameters: con, options: options);
    var responsejson = json.decode(response.toString());

    if (response.headers['set-cookie'] != null) {
      dio.options.headers['Cookie'] = {'Cookie' : response.headers['set-cookie'][0]};
    }

    if (responsejson["err"] == 2) {
      addPrefsValue("login", "");
    }
    return responsejson;
  }catch(e){
    return print('ERROR:======>${e}');
  }
}

Future getAjax(String url, Map<String, String> con) async {
  try{
    Options options = new Options(
      headers: dio.options.headers['Cookie']
    );

    Response response;
    response = await Dio().get(http + url, queryParameters: con , options: options,);
    var responsejson = json.decode(response.toString());
    
    if (responsejson["err"] == 2) {
      addPrefsValue("login", "");
    }
    return responsejson;
  }catch(e){
    return print('ERROR:======>${e}');
  }
}

// 初始化列表
void initList(context, cate) {  
  var pro = Provide.value<ItemList>(context);
  var catestr = getCatestr(cate);

  showPrefsList(catestr).then((v){
    bool syn = false; // 是否同步
    List listdata = [];

    for (var i = 0; i < v.length; i++) {
      var vjson = json.decode(v[i]);
      if (vjson["syn"] == 0) {
        syn = true;
        break;
      }
      listdata.add(vjson);
    }
    if ((syn || listdata.length == 0) && Provide.value<UserData>(context).login == "1") {
      // 同步
      getAjax(
        "IndexItem",
        {"cate": cate}
      ).then((val){
        if (val["err"] == 0) {
          PrintLog.e({"a1":val});
          List<String> listdata = [];
          for (var i = 0; i < val["data"].length; i++) {
            val["data"][i]["syn"] = "1";
            var jv = json.encode(val["data"][i]);
            listdata.add(jv);
          }
          addPrefsList(catestr, listdata);
          pro.changeList(val["data"], cate);
        } else {
          print(val);
        }
      });
    } else {
      // 不同步，获取本地的
      var p = pro.items.toString();
      switch(cate) {
        case "1":
          // 娱乐
          p = pro.plays.toString();
          break;
        case "2":
          // 明日
          break;
        case "3":
          // 月计划
          break;
        case "4":
          // 年计划
          break;
        default:
          break;
      }
      if (p != v) {
        pro.changeList(listdata, cate);
      }
    }

    topTodayData(context, 0, cate);
  });
}

// 登陆
void login(context, mobile, password) {
  postAjax(
    "Login",
    {"mobile": mobile, "password": password}
  ).then((val){
    Provide.value<GlobalData>(context).changeLoginLoading(false);
    if (val["err"] == 1) {
      Fluttertoast.showToast(
        msg: "用户名或密码错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (val["err"] == 0) {
      var jsondata = {
        "avatar": val["avatar"], 
        "mobile": val["mobile"], 
        "nickname": val["nickname"], 
        "heart": val["heart"], 
        "login": "1", 
      };
      var jv = json.encode(jsondata);
      addPrefsValue("login", jv);  
      initApp(context);
      Fluttertoast.showToast(
        msg: "登陆成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.push(context, NoRoute(page: new Index()));
    }
  });
}

// 注册
void register(context, mobile, password, nickname) {
  postAjax(
    "Register",
    {"mobile": mobile, "password": password, "nickname": nickname}
  ).then((val){
    Provide.value<GlobalData>(context).changeRegisterLoading(false);
    if (val["err"] == 1) {
      Fluttertoast.showToast(
        msg: "验证码错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (val["err"] == 0) {
      var jsondata = {
        "avatar": val["avatar"], 
        "mobile": mobile, 
        "nickname": nickname, 
        "heart": 0, 
        "login": "1", 
      };
      var jv = json.encode(jsondata);
      addPrefsValue("login", jv);  
      initApp(context);
      Fluttertoast.showToast(
        msg: "注册成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.push(context, NoRoute(page: new Index()));
    }
  });
}

// 修改昵称
void editMyNickname(context, nickname) {
  postAjax(
    "UserEdit",
    {"nickname": nickname}
  ).then((val){
    if (val["err"] == 0) {
      Navigator.of(context).pop();
      showPrefsValue("login").then((v){
        if (v != "") {
          var vjson = json.decode(v);
          vjson["nickname"] = nickname;
          var jv = json.encode(vjson);
          addPrefsValue("login", jv);  
          var pro = Provide.value<UserData>(context);
          pro.changeNickname(vjson["nickname"]);
        }
      });
      Fluttertoast.showToast(
        msg: "昵称修改成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
        msg: "昵称修改发生错误，请重试",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  });
}

// 今日任务：清单完成任务数百分比、任务数、完成任务数、清单获得心心数(item), 用户总心心数(user)
// 执行：完成(完成、取消)任务时，删除任务时，增加任务时，initApp
void topTodayData(context, int heart, cate) {
  var proitem = Provide.value<ItemList>(context);
  var proUser = Provide.value<UserData>(context);
  var lists = proitem.items;
  switch(cate) {
    case "1":
      // 娱乐
      lists = proitem.plays;
      break;
    case "2":
      // 明日
      break;
    default:
      break;
  }
  var itemTotal = lists.length; // 任务数
  var itemComplete = 0; // 完成任务数
  var heartTotal = proUser.heart; // 用户总心心数
  var heartComplete = 0; // 获得心心数或消费心心数
  double itemPercentage = 0.0; // 完成任务数百分比

  for (var i = 0; i < itemTotal; i++) {
    if (lists[i]["complete"] == "1") {
      itemComplete += 1;
      if (lists[i]["heart"] != null) {
        heartComplete += int.parse(lists[i]["heart"]);
      }
    }
  }

  itemPercentage = itemComplete/itemTotal;
  // 完成任务时改变用户心心
  if (heart != 0) {
    heartTotal += heart;
    editMyHeart(context, heartTotal);
  }
  if (itemPercentage.isNaN) {
    itemPercentage = 0.0;
  }
  proitem.changeData(cate, itemTotal, itemComplete, itemPercentage, heartComplete);
}

// 修改用户总心心
void editMyHeart(context, int heart) {
  var pro = Provide.value<UserData>(context);
  pro.changeHeart(heart);
  postAjax(
    "UserEdit",
    {"heart": heart.toString()}
  ).then((val) {
    if (val["err"] == 0) {
      showPrefsValue("login").then((v){
        if (v != "") {
          var vjson = json.decode(v);
          vjson["heart"] = heart;
          var jv = json.encode(vjson);
          addPrefsValue("login", jv);  
          var pro = Provide.value<UserData>(context);
          pro.changeHeart(vjson["heart"]);
        }
      });
    } else {
      print(val);
    }
  });
}

// 完成
void itemComplete(context, cate, index, value) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      vjson["complete"] = value;
      vjson["syn"] = "0";
      var id = vjson["id"];
      var heart = vjson["heart"];
      var jv = json.encode(vjson);
      v[index] = jv;
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.changeComplete(index, value, cate);
      int intheart;
      if (heart is String) {
        intheart = int.parse(heart);
      } else {
        intheart = heart;
      }
      if (value == "0") {
        intheart = -intheart;
      }
      topTodayData(context, intheart, cate);

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "complete": value}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                var vjson = json.decode(v[index]);
                vjson["syn"] = "1";
                var jv = json.encode(vjson);
                v[index] = jv;
                addPrefsList(catestr, v);
              }
            });
          } else {
            print(val);
          }
        });
      }

    }
  });
}

// 设为重要
void itemIm(context, cate, index, value) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      vjson["im"] = value;
      vjson["syn"] = "0";
      var id = vjson["id"];
      var jv = json.encode(vjson);
      v[index] = jv;
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.changeIm(index, value, cate);

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "im": value}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                var vjson = json.decode(v[index]);
                vjson["syn"] = "1";
                var jv = json.encode(vjson);
                v[index] = jv;
                addPrefsList(catestr, v);
              }
            });
          } else {
            print(val);
          }
        });
      }

    }
  });
}

// 编辑标题
void itemTitle(context, cate, index, value) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      vjson["title"] = value;
      vjson["syn"] = "0";
      var id = vjson["id"];
      var jv = json.encode(vjson);
      v[index] = jv;
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.changeTitle(index, value, cate);

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "title": value}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                var vjson = json.decode(v[index]);
                vjson["syn"] = "1";
                var jv = json.encode(vjson);
                v[index] = jv;
                addPrefsList(catestr, v);
              }
            });
          } else {
            print(val);
          }
        });
      }

    }
  });
}

// 编辑备注
void itemNote(context, cate, index, value) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      vjson["note"] = value;
      vjson["syn"] = "0";
      var id = vjson["id"];
      var jv = json.encode(vjson);
      v[index] = jv;
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.changeNote(index, value, cate);

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "note": value}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                var vjson = json.decode(v[index]);
                vjson["syn"] = "1";
                var jv = json.encode(vjson);
                v[index] = jv;
                addPrefsList(catestr, v);
              }
            });
          } else {
            print(val);
          }
        });
      }

    }
  });
}

// 编辑heart
void itemHeart(context, cate, index, value) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      vjson["heart"] = value;
      vjson["syn"] = "0";
      var id = vjson["id"];
      var jv = json.encode(vjson);
      v[index] = jv;
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.changeHeart(index, value, cate);

      Fluttertoast.showToast(
        msg: "😊 心心数已更改",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "heart": value.toString()}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                var vjson = json.decode(v[index]);
                vjson["syn"] = "1";
                var jv = json.encode(vjson);
                v[index] = jv;
                addPrefsList(catestr, v);
              }
            });
          } else {
            print(val);
          }
        });
      }

    }
  });
}

// 删除
void itemDel(context, index, cate) {
  Navigator.of(context).pop();
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    if (v != "") {
      var vjson = json.decode(v[index]);
      var id = vjson["id"];
      v.removeAt(index);
      addPrefsList(catestr, v);  
      var pro = Provide.value<ItemList>(context);
      pro.del(index, cate);

      Fluttertoast.showToast(
        msg: "删除成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );

      if (id != null && id != "") {
        postAjax(
          "EditItem",
          {"id": id, "status": "0"}
        ).then((val){
          if (val["err"] == 0) {
            showPrefsList(catestr).then((v){
              if (v != "") {
                pro.myDel.remove(id);
              }
            });
          } else {
            print(val);
          }
        });
      }
    }
  });
}

// 创建
void itemAdd(context, cate, title, heart, note) {
  var catestr = getCatestr(cate);
  showPrefsList(catestr).then((v){
    var item = {
      "id": "",
      "title": title.toString(),
      "note": note.toString(),
      "heart": heart.toString(),
      "cate": cate.toString(),
      "im": "0",
      "complete": "0",
      "syn": "0", 
    };
    var itemstr = json.encode(item);
    v.add(itemstr);
    var index = v.length;
    // json encode
    addPrefsList(catestr, v);  
    var pro = Provide.value<ItemList>(context);
    pro.add(json.decode(itemstr), cate);

    postAjax(
      "AddItem",
      {"title": title, "note": note, "heart": heart.toString()}
    ).then((val){
      if (val["err"] == 0) {
        showPrefsList(catestr).then((v){
          if (v != "") {
            var vjson = json.decode(v[index]);
            vjson["syn"] = "1";
            var jv = json.encode(vjson);
            v[index] = jv;
            // addPrefsList(catestr, v);
          }
        });
      } else {
        print(val);
      }
    });
  });
}