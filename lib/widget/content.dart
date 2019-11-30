import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/ajax_models.dart';
import './content_setting.dart';
import './content_clock.dart';
import '../provide/provide.dart';
import 'package:provide/provide.dart';

class ListsItemContent extends StatelessWidget {
  ListsItemContent({Key key, this.index, this.cate}) : super(key: key);
  final int index;
  final String cate;
  
  @override
  Widget build(BuildContext context) {
    return Provide<ItemList> (
      builder: (context, child, counter){
        String title;
        String im;
        String note;
        String complete;
        var c = counter.items;
        switch(cate) {
          case "1":
            // 娱乐
            c = counter.plays;
            break;
          case "2":
            // 明日
            break;
          default:
            break;
        }
        if (c.length != 0) {
          title = c[index]["title"];
          im = c[index]["im"];
          note = c[index]["note"];
          complete = c[index]["complete"];
        }
        int heart = 0;
        heart = int.parse(c[index]["heart"]);
        return Scaffold(
          appBar: new AppBar(
            // iconTheme: IconThemeData(),
            // backgroundColor: Colors.white,
            title: Text("今日任务详情"),
            elevation: 2,
          ),
          body: new Container(
            child: ListView(
              children: <Widget>[
                Titles(index: index, title: title, im: im, complete: complete, heart: heart, cate: cate),
                Mark(index: index, cate: cate, note: note),
                cate == "0" ? AddTomorrow(index: index, title: title, heart: heart, note: note) : Container(),
                Operation(index: index, cate: cate, heart: heart),
              ],
            ),
          ),
        );
      }
    );
  }
}

// 任务详情-标题
class Titles extends StatefulWidget {
  Titles({Key key, this.index, this.title, this.im, this.complete, this.heart, this.cate}) : super(key: key);
  final int index;
  final String title;
  final String im;
  final String complete;
  final int heart;
  final String cate;

  @override
  _TitlesState createState() => _TitlesState();
}

class _TitlesState extends State<Titles> {
  TextEditingController titleController = TextEditingController();
  var complete = "0";

  @override
  void initState() {
    titleController.text = this.widget.title;
    complete = this.widget.complete;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
      ),  
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                complete = complete == "1" ? "0" : "1";
                itemComplete(context, this.widget.cate, this.widget.index, complete);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 7.0, left: 7.0),
              child: complete == "1" ? Icon(Icons.check_box, color: Colors.green, size: 32.0) 
                : Icon(Icons.check_box_outline_blank, color: toColor("#8c8c8c"), size: 32.0),
            ),
          ),
          Expanded(
            child: Container(
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: titleController,
                style: complete == "1" ? 
                  TextStyle(fontSize: 21, decoration: TextDecoration.lineThrough, color: toColor('#8c8c8c'),) 
                  : TextStyle(fontSize: 21),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '修改标题',
                  labelStyle: TextStyle(fontSize: 15.0),
                ),
                keyboardType: TextInputType.text,
                onChanged: (value){
                  setState(() {
                    if (value != "") {
                      itemTitle(context, this.widget.cate, this.widget.index, value);
                    }                 
                  });
                },
              ),
            ),
          ),
          // Padding(padding: EdgeInsets.only(right: 5.0, left: 0.0),),
          // ChoiceChip(
          //   backgroundColor: toColor('#e8e8e8'),
            // avatar: CircleAvatar(
            //   backgroundColor: toColor('#e8e8e8'),
            //   child: Icon(Icons.favorite, color: Colors.red, size: 20,),
            // ),
          //   label: Text('+ ' + this.widget.heart.toString(), style:TextStyle(fontSize: 13)),
          //   selected: false,
          //   onSelected: (bool selected) => null,
          // ),
          InkWell(
            onTap: (){
              setState(() {
                var im = this.widget.im == "1" ? "0" : "1";
                itemIm(context, this.widget.cate, this.widget.index, im);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 1.0, left: 5.0),
              child: this.widget.im == "1" ? 
                Icon(Icons.star, color: Colors.blue, size: 32.0) 
                : Icon(Icons.star_border, color: toColor("#8c8c8c"), size: 32.0),
            ),
          ),
        ],
      ),
    );
  }
}

class Mark extends StatefulWidget {
  Mark({Key key, this.index, this.cate, this.note}) : super(key: key);
  final int index;
  final String cate;
  final String note;

  @override
  _MarkState createState() => _MarkState();
}

class _MarkState extends State<Mark> {
  var texts = "";
  TextEditingController noteController = TextEditingController();
  
  @override
  void initState() {
    texts = this.widget.note;
    noteController.text = this.widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
        border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
      ),
      height: 145,
      child: TextField(
        controller: noteController,
        maxLength: 100,
        maxLines: 5,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: '备注',
          // labelStyle: TextStyle(fontSize: 15.0),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            itemNote(context, this.widget.cate, this.widget.index, value);
          });
        },
      ),
    );
  }
}

// 操作-添加到“明日规划”
class AddTomorrow extends StatelessWidget {
  AddTomorrow({Key key, this.index, this.title, this.heart, this.note}) : super(key: key);
  final int index;
  final String title;
  final int heart;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
        border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
      ),
      child: Material(
        borderRadius: BorderRadius.all(const Radius.circular(8.0)),
        // 圆角水波纹
        child: Ink(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.all(const Radius.circular(8.0)),
            onTap: (){
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("是否添加"),
                    content: Text("确定要添加到 “明日规划” 吗？"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("确定", style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          // Provide.value<TomorrowList>(context).addt(title, heart, note);
                          Navigator.of(context).pop();
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
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.add_circle_outline, size: 30, color: Colors.blueGrey,),
                    Text('  添加到"明日规划"', style:TextStyle(fontSize: 16.0))
                  ],),
                  Icon(Icons.keyboard_arrow_right,size: 30,color: Colors.blueGrey,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 任务详情-操作
class Operation extends StatelessWidget {
  Operation({Key key, this.index, this.cate, this.heart, this.state}) : super(key: key);
  final int index;
  final String cate;
  final int heart;
  final String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
        border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
      ),
      child: Column(
        children: <Widget>[
          cate == "0" || cate == "1" ? TomatoSetting() : Container(),
          cate == "0" ? new Divider(color: Colors.black12, height: 1,) : Container(),
          Material(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
            // 圆角水波纹
            child: Ink(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
              ),
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Setting(index: index, cate: cate, heart: heart);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Icon(Icons.favorite_border, size: 30, color: Colors.red,),
                        Text("  心心设置", style:TextStyle(fontSize: 16.0))
                      ],),
                      Icon(Icons.keyboard_arrow_right,size: 30,color: Colors.red,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.black12, height: 1,),
          Material( 
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
            child: Ink(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                onTap: () {
                  dele(context, index, cate);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child:Row(children: <Widget>[
                          Icon(Icons.delete_forever, size: 30, color: Colors.grey),
                          Text("  删除此项", style:TextStyle(fontSize: 16.0))
                        ],)
                      ),
                      Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}

void dele(BuildContext context, int index, String cate) {
  showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("删除"),
        content: Text("确定要删除该项任务吗？"),
        actions: <Widget>[
          FlatButton(
            child: Text("删除", style: TextStyle(color: Colors.red)),
            onPressed: () {
              itemDel(context, index, cate);
              Navigator.of(context).pop();
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

// 任务详情-操作-删除此项
class ItemDel extends StatelessWidget {
  ItemDel({Key key, this.index, this.cate}) : super(key: key);
  final int index;
  final String cate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
        border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
      ),
      child : Material( 
        borderRadius: BorderRadius.all(const Radius.circular(8.0)),
        child: Ink(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.all(const Radius.circular(8.0)),
            onTap: () {
              dele(context, index, cate);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child:Row(children: <Widget>[
                      Icon(Icons.delete_forever, size: 30, color: Colors.grey),
                      Text("  删除此项", style:TextStyle(fontSize: 16.0))
                    ],)
                  ),
                  Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 任务详情-操作-番茄计时
class TomatoSetting extends StatefulWidget {
  @override
  _TomatoSettingState createState() => _TomatoSettingState();
}

class _TomatoSettingState extends State<TomatoSetting> {
  void tomato(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("🍅"),
          content: Text("本次番茄计时完成"),
          actions: <Widget>[
            FlatButton(
              child: Text("再来一次", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.push(context, SlideRightRoute(page: new TomatoClock(duration: timeDuration)));
              },
            ),
            FlatButton(
              child: Text("算了，退出", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            ),
          ],
        );
      },
    );
  }

  void custom(BuildContext context, int index) {
    var time = "25";
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("自定义番茄时间设置"),
          content: TextField(
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "25分钟",
              labelStyle: TextStyle(fontSize: 15.0),
            ),
            onChanged: (text){
              setState(() {
                time = text;   
              });
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                setState(() {
                  var timed = double.parse(time).toInt();
                  if (timed >= 100) {
                    timed = 99;
                  }
                  if (timed >= 0) {
                    timed = 1;
                  }
                  Provide.value<TomatoTimes>(context).changeCustom(timed);
                  timeDuration = Duration(minutes: timed);
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

  var timeId = 3;
  var timeDuration = Duration(minutes: 10);

  void tomatoBefore(BuildContext context) {
    timeId = 2;
    Provide.value<TomatoTimes>(context).changeCustomRe();
    showDialog<bool>(
      context: context,
      builder: (context) {
        // 动态循环渲染
        return StatefulBuilder(
          builder: (context, state) {
            return AlertDialog(
              title: Text("选择番茄时间"),
              content: Provide<TomatoTimes> (
                builder: (context, child, counter){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("请选择番茄计时："),
                      Padding(padding: const EdgeInsets.only(top: 10.0),),
                      Container(
                        height: 95.0, // Change as per your requirement
                        width: 250.0, // Change as per your requirement
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //每行三列
                            childAspectRatio: 1.5, //显示区域宽高相等
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 20.0
                          ),
                          itemCount: counter.tomatoChoiceChip.length,
                          itemBuilder: (context, index) {
                            return ChoiceChip(
                              backgroundColor: toColor('#e8e8e8'),
                              label: Text(counter.tomatoChoiceChip[index].text),
                              selected: counter.tomatoChoiceChip[index].selectId == timeId,
                              onSelected: (bool selected) async {
                                state(() {
                                  timeId = counter.tomatoChoiceChip[index].selectId;
                                  timeDuration = counter.tomatoChoiceChip[index].time;
                                  if (counter.tomatoChoiceChip[index].selectId == 5) {
                                    custom(context, index);
                                    Provide.value<TomatoTimes>(context).changeCustom(25);
                                    timeDuration = Duration(minutes: 25);
                                  }
                                });
                              },
                            );
                          }
                        ),
                      ),
                    ]
                  );
                }
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("开始番茄计时", style: TextStyle(color: Colors.blue)),
                  onPressed: () async {
                    var result = await Navigator.push(context, SlideRightRoute(page: new TomatoClock(duration: timeDuration)));
                    if (result != null) {
                      tomato(context);
                    }
                  },
                ),
                FlatButton(
                  child: Text("取消", style: TextStyle(color: Colors.black)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
        // 圆角水波纹
        child: Ink(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
            onTap: () {
              tomatoBefore(context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.access_alarm, size: 30, color: Colors.orange,),
                    Text("  番茄时钟", style:TextStyle(fontSize: 16.0))
                  ],),
                  Icon(Icons.keyboard_arrow_right,size: 30,color: Colors.orange,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}