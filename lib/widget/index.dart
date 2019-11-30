import 'package:flutter/material.dart';
import 'package:myplan/config/config.dart';
import '../models/models.dart';
import '../widget/drawer.dart';
import '../config/config.dart';
import '../page/today/work.dart';
import '../page/today/play.dart';
import 'package:provide/provide.dart';
import '../provide/provide.dart';
import '../widget/add.dart';
import 'package:flutter_colorpicker/block_picker.dart';

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
    _tabcontroller.addListener((){
      int cate = _tabcontroller.index;
      if (currentIndex == 1) {
        cate = cate + 3;
      }
      switch (cate) {
        case 0: 
          // setState(() {
            myColor = Provide.value<ColorData>(context).work;
            Provide.value<ColorData>(context).changeCate(cate);
          // });
          break;
        case 1: 
          // setState(() {
            myColor = Provide.value<ColorData>(context).play;
            Provide.value<ColorData>(context).changeCate(cate);
          // });
          break;
        default:
      }
    });
    super.initState();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // create some values
  Color pickerColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void colorPick(BuildContext context, int cate) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择主题色'),
          content: SingleChildScrollView(
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   enableLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            child: BlockPicker(
              pickerColor: myColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('确定'),
              onPressed: () {
                setState(() {
                  switch (cate) {
                    case 0: 
                      Provide.value<ColorData>(context).changeWork(pickerColor);
                      break;
                    case 1: 
                      Provide.value<ColorData>(context).changePlay(pickerColor);
                      break;
                    default:
                  }
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
    Widget bottomTab = TabBar(
      controller: _tabcontroller,
      tabs: tabs[currentIndex],
      indicatorSize: TabBarIndicatorSize.tab,
    );
    
    List<Widget> bodys = [
      TabBarView(
        children: <Widget>[
          Work(),
          Play(),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () {
              int cate = _tabcontroller.index;
              if (currentIndex == 1) {
                cate = cate + 3;
              }
              colorPick(context, cate);
            },
          )
        ],
      ),
      body: bodys[currentIndex],
      drawer: MyDrawer(),
      bottomNavigationBar: BottomAppBar(
        shape:CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 0;
                  myTabs = tabs[currentIndex]; 
                });
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.timer, color: currentIndex == 0 ? myColor : Colors.black38),
                    Text(title[0], style: TextStyle(color: currentIndex == 0 ? myColor : Colors.black38))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  myTabs = tabs[currentIndex]; 
                });
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.event_note, color: currentIndex == 1 ? myColor : Colors.black38),
                    Text(title[1], style: TextStyle(color: currentIndex == 1 ? myColor : Colors.black38))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
          var cate = _tabcontroller.index;
          if (currentIndex == 1) {
            cate = cate + 3;
          }
          Navigator.push(context, SlideTopRoute(page: new AddItem()));
        },
        child: Icon(
          Icons.add,
        ),
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