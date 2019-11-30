import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/provide.dart';
import '../models/models.dart';
import '../page/today/work.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 写log
class DayLogs extends StatefulWidget {
  DayLogs({Key key, this.cate}) : super(key: key);
  final int cate;
  @override
  _DayLogsState createState() => _DayLogsState();
}

class _DayLogsState extends State<DayLogs> {
  String title = "写日志";
  String text = "";
  final _logController = TextEditingController();

  Future<bool> back(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("当前有未保存的内容，您需要保存后再退出吗？"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                save(context);
                Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text("保存后退出", style: TextStyle(color: Colors.blue),),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text("不保存退出"),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text("不退出"),
              ),
            ),
          ],
        );
      },
    );
  }

  save(context) {
    switch(this.widget.cate) {
      case 0:
        // 今日日志
        Provide.value<Log>(context).add(_logController.text);
        break;
      case 1:
        // 本月月志
        Provide.value<Log>(context).addMonth(_logController.text);
        break;
      case 2:
        // 今年年志
        Provide.value<Log>(context).addYear(_logController.text);
        break;
      default:
        break;
    }
    Fluttertoast.showToast(
      msg: "保存成功",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  @override
  void initState() {
    // 等待页面build后再执行
    WidgetsBinding.instance.addPostFrameCallback((_){
      switch(this.widget.cate) {
        case 0:
          // 今日日志
          text = Provide.value<Log>(context).log;
          title = "写日志";
          break;
        case 1:
          // 本月月志
          text = Provide.value<Log>(context).logMonth;
          title = "写月志";
          break;
        case 2:
          // 今年年志
          text = Provide.value<Log>(context).logYear;
          title = "写年志";
          break;
        default:
          break;
      }
      _logController.text = text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var no = true;
        if (Provide.value<Log>(context).log == _logController.text) {
          no = false;
        }
        return no ? back(context).then((v){
          if (v == null) {
            return false;
          } else {
            return v;
          }
        }) : true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(title, style: TextStyle(color: Colors.black)),
          elevation: 1,
          actions: <Widget>[
            FlatButton(
              child: Text("保存"),
              onPressed: () {
                save(context);
              },
            ),
          ],
        ),
        body: new Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
          child: TextField(
            controller: _logController,
            maxLength: 400,
            maxLines: null,
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "请输入……",
              labelStyle: TextStyle(fontSize: 15.0),
            ),
          ),
        )
      )
    );
  }
}