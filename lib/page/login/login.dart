import 'package:flutter/material.dart';
import '../../models/ajax_models.dart';
import '../../models/models.dart';
import '../../widget/index.dart';
import '../../provide/provide.dart';
import './register.dart';
import './Passwordlogin.dart';
import 'package:provide/provide.dart';
import 'package:loading_button/loading_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool pwdShow = false;
  
  String validatorMobile(String mobile) {
    if (mobile.length == 0) {
      return "手机号不能为空";
    }
    return null;
  }

  String validatorPassWord(String p) {
    if (p.length == 0) {
      return "密码不能为空";
    } 
    if (p.length < 6) {
      return "密码不能小于6位";
    } 
    if (p.length > 20) {
      return "密码不能大于20位";
    }
    return null;
  }

  void see(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("游客模式"),
          content: Text("确定要以游客模式浏览吗？有一些功能需要登陆后才能使用。"),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.push(context, NoRoute(page: new Index()));
              },
            ),
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text('登陆', style: TextStyle(color: Colors.black))
      ),
      body: new Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: new Form(
          key: _formKey, //设置globalKey，用于后面获取FormState
          // autovalidate: true, //开启自动校验
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Container(
                alignment: Alignment.center,
                height: 100,
                child: Image.asset(
                  "static/imgs/list.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                onChanged: (String text){
                },
                decoration: const InputDecoration(
                  prefixIcon:Icon(Icons.phone_android),
                  labelText: '手机号',
                  labelStyle: TextStyle(fontSize: 15.0),
                  // border: InputBorder.none,
                ),
                validator: (v) {
                  return validatorMobile(v.trim());
                }
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !pwdShow,
                keyboardType: TextInputType.text,
                onChanged: (String text){
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: '密码',
                  labelStyle: TextStyle(fontSize: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                  )
                ),
                validator: (v) {
                  return v
                    .trim()
                    .length > 0 ? null : "密码不能为空";
                }
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Ink(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, NoRoute(page: new Passwordlogin()));
                      },
                      child:Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text("忘记密码",),
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, NoRoute(page: new Register()));
                    },
                    child: Text('注册', style: TextStyle(color: Colors.blue)),
                  ),
                  ButtonLoading(formKey: _formKey, mobileController: _mobileController, passwordController: _passwordController),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        see(context);
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.people, color: Colors.black45),
                          Text(' 游客模式', style: TextStyle(color: Colors.black45)),
                        ],
                      )
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonLoading extends StatefulWidget {
  ButtonLoading({Key key, this.formKey, this.mobileController, this.passwordController}) : super(key: key);
  final formKey;
  final mobileController;
  final passwordController;

  @override
  _ButtonLoadingState createState() => _ButtonLoadingState();
}

class _ButtonLoadingState extends State<ButtonLoading> {
  @override
  Widget build(BuildContext context) {
    return Provide<GlobalData>(
      builder: (context, child, counter) {
        return LoadingButton(
          onPressed: (){
            setState(() {
              if((this.widget.formKey.currentState as FormState).validate()) {
                counter.changeLoginLoading(true);
                //验证通过提交数据
                String mobile = this.widget.mobileController.text;
                String password = this.widget.passwordController.text;
                login(context, mobile, password);
              }
            });
          },
          isLoading: counter.loginLoading,
          child: Text(
            "登陆",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    );
  }
}
