import 'package:flutter/material.dart';

// app名字
String appName = "远虑";

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

// 全局color
Color myColor = Colors.blue;

// heart chip
List heartChip = [
  {"name": "一颗", "value": 1}, 
  {"name": "三颗", "value": 3},
  {"name": "五颗", "value": 5}, 
  {"name": "八颗", "value": 8},
  {"name": "十颗", "value": 10}, 
];