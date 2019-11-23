import 'package:flutter/material.dart';
import 'dart:async';

int time = 60;
Timer _timer;
var fas = "发送验证码";

// 忘记密码
class Passwordlogin extends StatefulWidget {
  @override
  _PasswordwxPageState createState() => _PasswordwxPageState();
}

class _PasswordwxPageState extends State<Passwordlogin> {

  final _mobileController=TextEditingController();
  final _passwordController=TextEditingController();
  final _passwordControllerRe=TextEditingController();
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
    super.initState();
    stopTime();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 2,
        title: Text('密码重置', style: TextStyle(color: Colors.black))
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
            obscureText: true,
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
            height: 12.0,
          ),
          TextFormField(
            controller: _passwordControllerRe,
            obscureText: true,
            keyboardType: TextInputType.number,
            onChanged: (String text){
            },
            decoration: const InputDecoration(
              prefixIcon:Icon(Icons.remove_red_eye),
              labelText: '确认密码',
              labelStyle: TextStyle(fontSize: 15.0),
            ),
            validator: (v) {
              print(v);
              return v == _passwordController.text ? null : "密码不一致";
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
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if((_formKey.currentState as FormState).validate()){
                    //验证通过提交数据
                  }
                },
                child: Text('重置密码',style: TextStyle(color: Colors.white),),
              ),
            ],
          )
        ],
      )),
    );
  }
}