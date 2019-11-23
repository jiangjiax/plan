import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/ajax_models.dart';
import '../../provide/provide.dart';
import 'package:provide/provide.dart';
import 'package:loading_button/loading_button.dart';

int time = 60;
Timer _timer;
var fas = "发送验证码";

// 注册
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _mobileController=TextEditingController();
  final _passwordController=TextEditingController();
  final _yzmController=TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();

  void startTime() {
    fas = "已发送 $time";
    _timer = new Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        time--;
        fas = "已发送 $time";
        if(time < 1){
          stopTime();
        }
      });
    });
  }

  void stopTime() {
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {
      fas = "发送验证码";
      time = 60;
    });
    _timer = null;
  }

  @override
  void initState() {
    stopTime();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  void custom(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("自定义番茄时间设置"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "25分钟",
              labelStyle: TextStyle(fontSize: 15.0),
            ),
            onChanged: (text){
              setState(() {
              });
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colors.black)),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 2,
        title: Text('注册', style: TextStyle(color: Colors.black))
      ),
      body: Form(
        key: _formKey, //设置globalKey，用于后面获取FormState
        // autovalidate: true, //开启自动校验
        child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
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
                      return v
                        .trim()
                        .length > 0 ? null : "手机号不能为空";
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child:new OutlineButton(
                      onPressed: (){
                        setState(() {
                          startTime();                          
                        });
                      },
                      child: Text(fas),
                    ),
                  )
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: _yzmController,
            keyboardType: TextInputType.number,
            onChanged: (String text){
            },
            decoration: const InputDecoration(
              prefixIcon:Icon(Icons.speaker_notes),
              labelText: '验证码',
              labelStyle: TextStyle(fontSize: 15.0),
            ),
            validator: (v) {
              print(v);
              return v
                .trim()
                .length > 0 ? null : "验证码不能为空";
            }
          ),
          SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.text,
            onChanged: (String text){
            },
            decoration: const InputDecoration(
              prefixIcon:Icon(Icons.remove_red_eye),
              labelText: '密码',
              labelStyle: TextStyle(fontSize: 15.0),
            ),
            validator: (v) {
              return v
                .trim()
                .length > 0 ? null : "密码不能为空";
            }
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('返回登陆'),
              ),
              ButtonLoading(formKey: _formKey, mobileController: _mobileController, passwordController: _passwordController),
            ],
          )
        ],
      )),
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
                counter.changeRegisterLoading(true);
                //验证通过提交数据
                String mobile = this.widget.mobileController.text;
                String password = this.widget.passwordController.text;
                String nickname = "用户" + mobile;
                register(context, mobile, password, nickname);
              }
            });
          },
          isLoading: counter.loginLoading,
          child: Text(
            "注册",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    );
  }
}