import 'package:flutter/material.dart';
import '../page/login/login.dart';
import '../models/models.dart';
import '../models/ajax_models.dart';
import 'package:provide/provide.dart';
import '../provide/provide.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          TopUser(),
          ListTile(
            leading: new CircleAvatar(
              child: new Icon(Icons.help),
            ),
            title: Text("查看帮助"),
          ),
          ListTile(
            leading: new CircleAvatar(
              child: new Icon(Icons.mail),
            ),
            title: Text("建议信箱"),
          ),
        ],
      ),
    );
  }
}

class TopUser extends StatefulWidget {
  @override
  _TopUserState createState() => _TopUserState();
}

class _TopUserState extends State<TopUser> with SingleTickerProviderStateMixin{

  void logout(BuildContext context, counter) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("注销"),
          content: Text("确定要重新登陆吗？"),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                removePrefs("login");
                counter.logout();
                Navigator.push(context, NoRoute(page: new Login()));
              },
            ),
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Provide<UserData>(
      builder: (context, child, counter) {
        return UserAccountsDrawerHeader(
          decoration: new BoxDecoration(
            color: Colors.white38,
          ),
          accountName: Container(
            child: Row(
              children: <Widget>[
                new Text(counter.nickname, style: TextStyle(color: Colors.black)),
                counter.login == "1" ? EditName(nickname: counter.nickname) : Container(height: 0,),
              ],
            ),
          ),
          accountEmail: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(counter.mobile, style: TextStyle(color: Colors.black)),
                Container(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(Icons.exit_to_app, color: Colors.blueAccent, size: 20,),
                        ),
                        Text(counter.login == "0" ? "登陆" : "注销", style: TextStyle(color: Colors.blueAccent)),
                      ],
                    ),
                    onTap: () {
                      if (counter.login == "1") {
                        // removePrefs("login");
                        // counter.logout();
                        logout(context, counter);
                      } else {
                        Navigator.push(context, NoRoute(page: new Login()));
                      }
                    },
                  )
                )
              ],
            ),
          ),
          currentAccountPicture: counter.login == "1" ? CircleAvatar(
            backgroundColor: Colors.black26,
            backgroundImage: new NetworkImage(counter.avatar),
          ) : CircleAvatar(
            backgroundColor: Colors.black26,
            child: Text("未登录", style: TextStyle(color: Colors.white, fontSize: 12), ),
          ),
        );
      }
    );
  }
}

class EditName extends StatefulWidget {
  EditName({Key key, this.nickname}) : super(key: key);
  final nickname;

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {

  final _tipController = TextEditingController();

  @override
  void initState() {
    _tipController.text = this.widget.nickname;
    super.initState();
  }

  void custom(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("修改昵称"),
          content: TextField(
            maxLength: 10,
            controller: _tipController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "请输入昵称",
              labelStyle: TextStyle(fontSize: 15.0),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                editMyNickname(context, _tipController.text);
              },
            ),
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        child: Icon(Icons.create, color: Colors.black54, size: 20,),
        onTap: () {
          custom(context);
        },
      ),
    );
  }
}