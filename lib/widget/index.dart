import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widget/drawer.dart';
import '../config/config.dart';
import '../page/today/work.dart';
import 'package:provide/provide.dart';
import '../provide/provide.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  var myTabs = tabs[currentIndex];
  static TabController _tabcontroller;
  static int currentIndex = 0;

  @override
  void initState() {
    _tabcontroller = TabController(length: myTabs.length, vsync: this);
    super.initState();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget bottomTab = TabBar(
      controller: _tabcontroller,
      tabs: tabs[currentIndex],
      indicatorSize: TabBarIndicatorSize.tab,
    );
    
    List<Widget> bodys = [
      TabBarView(
        children: <Widget>[
          Work(),
          Container(color:Colors.red,),
          Container(color:Colors.blue,)
        ],
        controller: _tabcontroller,
      ),
      Container(child: Text("data2"),)
      // Plan()
    ];
    
    return Scaffold (
      key: _drawerKey,
      appBar: new AppBar(
        bottom: bottomTab,
        leading: OpenDrawPic(drawerKey: _drawerKey,),
        elevation: 0,
        title: new Text(title[currentIndex],),
      ),
      body: bodys[currentIndex],
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            myTabs = tabs[currentIndex];
          });
        },
      ),
    );
  }
}

class OpenDrawPic extends StatefulWidget {
  OpenDrawPic({Key key, this.drawerKey}) : super(key: key);
  final drawerKey;

  @override
  _OpenDrawPicState createState() => _OpenDrawPicState();
}

class _OpenDrawPicState extends State<OpenDrawPic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<UserData>(
        builder: (context, child, counter) {
          return IconButton(
            icon: new Container(
              child: counter.login == "0" ? CircleAvatar(
                radius: 40.0,
                backgroundColor: toColor("#e8e8e8"),
                child: Text("未登录", style: TextStyle(fontSize: 10)),
              ) : CircleAvatar(
                backgroundColor: Colors.black26,
                backgroundImage: new NetworkImage(counter.avatar),
              ),
            ),
            onPressed: () {
              this.widget.drawerKey.currentState.openDrawer();
            },
          );
        }
      )
    );
  }
}