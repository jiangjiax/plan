import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'dart:async';

class TomatoClock extends StatefulWidget {
  TomatoClock({Key key, this.duration}) : super(key: key);
  final Duration duration;

  @override
  _TomatoClockState createState() => _TomatoClockState();
}

class _TomatoClockState extends State<TomatoClock> {
  static bool reback = false;

  bool re() {
    return true;
  }

  Future<bool> back(context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("退出"),
          content: Text("确定要退出计时吗？"),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop(true);
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return back(context).then((v){
          if (v == null) {
            return false;
          } else {
            return v;
          }
        });
      },
      child: Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text("番茄计时", style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        body: new Container(
          color: Colors.white,
          child: TimerWidget(duration: this.widget.duration)
        )
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  TimerWidget({Key key, this.duration}) : super(key: key);
  final Duration duration;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin {
  // static Duration _duration = this.widget.times;
  String _buttonText = '暂停';
  Timer timer;
  var tick = Duration(seconds: 1);
  var _endTime;

  static String getDisplayTime(Duration time) {
    int minutes = time.inMinutes;
    int seconds = (time.inSeconds - (time.inMinutes * 60));
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String _displayTime;
  Duration _countdown;

  @override
  void initState() {
    _displayTime = getDisplayTime(this.widget.duration);
    _endTime = DateTime.now().add(this.widget.duration);
    _countdown = this.widget.duration;
    if (!DateTime.now().isAfter(_endTime)) {
      startTimer(context);
    }
    super.initState();
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // 时间转动
  void startTimer(BuildContext context) {
    setState(() {
      _buttonText = '暂停';
      if (_countdown != this.widget.duration) {
        _endTime = DateTime.now().add(_countdown);
      } else {
        _displayTime = getDisplayTime(this.widget.duration-tick);
      }
      timer = Timer.periodic(tick, (Timer timer) {
        setState(() {
          _countdown = _endTime.difference(DateTime.now());
          _displayTime = getDisplayTime(_countdown);
          if (DateTime.now().isAfter(_endTime)) {
            stopTimer();
            Navigator.of(context).pop("1");
          }
        });
      });
    });
  }
  
  void stopTimer() => setState(() {
    _buttonText = '开始';
    timer.cancel();
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          width: 300,
          child: CircularProgressIndicator(
            // backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange), 
            value: _countdown.inMilliseconds / this.widget.duration.inMilliseconds
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _displayTime,
                  style: TextStyle(color: Colors.orange, fontSize: 30),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.only(top: 4.0)),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text(_buttonText),
              onPressed: (){
                if (timer.isActive) {
                  stopTimer();
                } else {
                  startTimer(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}