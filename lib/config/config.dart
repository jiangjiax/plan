import 'package:flutter/material.dart';

// app名字
String appName = "远虑";

// index

// title
var title = [ '当前执行' , '长远计划' ];
// mytab
List<Tab> todaymyTabs = <Tab>[
  new Tab(text: '今日任务'),
  new Tab(text: '娱乐/休息'),
  new Tab(text: '明日规划'),
];
List<Tab> planmyTabs = <Tab>[
  new Tab(text: '日志'),
  new Tab(text: '月计划'),
  new Tab(text: '年计划'),
];
List tabs = [todaymyTabs, planmyTabs];
// BottomNavigationBar
final List<BottomNavigationBarItem> bottomTabs = [
  BottomNavigationBarItem(
    icon: Icon(Icons.timer),
    title: Text('当前执行')
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.event_note),
    title: Text('长远计划')
  ),
];

// 全局color
Color myColor = Colors.blue;
