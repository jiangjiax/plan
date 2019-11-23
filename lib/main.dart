import 'package:flutter/material.dart';
import './config/config.dart';
import './provide/provide.dart';
import './models/models.dart';
import './widget/index.dart';
import 'package:provide/provide.dart';

void main(){
  var itemList = ItemList();
  var globalData = GlobalData();
  var userData = UserData();
  var providers = Providers();
  
  providers.provide(Provider<ItemList>.value(itemList));
  providers.provide(Provider<GlobalData>.value(globalData));
  providers.provide(Provider<UserData>.value(userData));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initApp(context);
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: myColor,
        accentColor: myColor,
        iconTheme: IconThemeData(color: myColor),
      ),
      home: Index(),
    );
  }
}