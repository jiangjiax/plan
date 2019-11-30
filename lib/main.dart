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
  var log = Log();
  var providers = Providers();
  var colorData = ColorData();
  var tomatoTimes = TomatoTimes();

  providers.provide(Provider<ItemList>.value(itemList));
  providers.provide(Provider<GlobalData>.value(globalData));
  providers.provide(Provider<UserData>.value(userData));
  providers.provide(Provider<Log>.value(log));
  providers.provide(Provider<ColorData>.value(colorData));
  providers.provide(Provider<TomatoTimes>.value(tomatoTimes));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initApp(context);
    return Provide<ColorData>(
      builder: (context, child, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            primarySwatch: myColor,
            accentColor: myColor,
            // iconTheme: IconThemeData(color: myColor),
          ),
          home: Index(),
        );
      }
    );
  }
}