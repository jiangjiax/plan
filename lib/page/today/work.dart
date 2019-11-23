import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../config/config.dart';
import '../../models/tool_models.dart';
import '../../models/ajax_models.dart';
import 'package:provide/provide.dart';
import '../../provide/provide.dart';

class Work extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              TopDate(),
              TopHellow(),
              Lists()
              // Divider(height: 0,)
            ]),
          )
        ]
      ),
    );
  }
}

// 数据显示
class TopDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<ItemList>(
      builder: (context, child, counter) {
        return Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 58,
                    alignment: Alignment.center,
                    child: myProgress(counter.itemPercentage, 54),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    height: 58,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Provide<UserData>(
                          builder: (context, child, counters) {
                            return Container(
                              padding: const EdgeInsets.only(top: 5.0, left: 5),
                              // alignment: Alignment.topLeft,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.favorite, color: Colors.red, size: 17,),
                                  Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                        text: " 总数",
                                        style: TextStyle(color: Colors.black45, fontSize: 13.0),
                                      ),
                                      TextSpan(
                                        text: " ${counters.heart}",
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                    ]
                                  )),
                                ],
                              ),
                            );
                          }
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5.0, left: 5),
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.favorite, color: Colors.red, size: 17,),
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: " 获得",
                                    style: TextStyle(color: Colors.black45, fontSize: 13.0),
                                  ),
                                  TextSpan(
                                    text: " ${counter.heartComplete}",
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                ]
                              )),
                            ],
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
              RaisedButton.icon(
                color: myColor,
                icon: Icon(Icons.edit, color: Colors.white,),
                label: Text("写日志", style: TextStyle(color: Colors.white)),
                onPressed: (){
                  topTodayData(context,0);
                  print(Provide.value<ItemList>(context).items[0]);
                },
              ),
            ],
          )
        );
      }
    );
  }
}

class TopHellow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<ItemList>(
      builder: (context, child, counter) {
        return Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Provide<UserData>(
                      builder: (context, child, counters) {
                        return Text.rich(TextSpan(
                          children: [
                            TextSpan(
                              text: "你好, ",
                              style: TextStyle(color: myColor, fontSize: 20),
                            ),
                            TextSpan(
                              text: counters.nickname,
                              style: TextStyle(color: Colors.black45, ),
                            ),
                          ]
                        ));
                      }
                    ),
                    Padding(padding: const EdgeInsets.only(top: 2)),
                    Text.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "下面是你的",
                          style: TextStyle(color: Colors.black45),
                        ),
                        TextSpan(
                          text: " 今日任务 ",
                          style: TextStyle(color: myColor, ),
                        ),
                        TextSpan(
                          text: "清单, ",
                          style: TextStyle(color: Colors.black45, ),
                        ),
                      ]
                    )),
                    Padding(padding: const EdgeInsets.only(top: 4)),
                    Text.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "共有",
                          style: TextStyle(color: Colors.black45,),
                        ),
                        TextSpan(
                          text: " ${counter.itemTotal} ",
                          style: TextStyle(color: myColor, ),
                        ),
                        TextSpan(
                          text: "项任务, ",
                          style: TextStyle(color: Colors.black45,),
                        ),
                        TextSpan(
                          text: "已完成",
                          style: TextStyle(color: Colors.black45,),
                        ),
                        TextSpan(
                          text: " ${counter.itemComplete} ",
                          style: TextStyle(color: myColor, ),
                        ),
                        TextSpan(
                          text: "项任务.",
                          style: TextStyle(color: Colors.black45,),
                        ),
                      ]
                    )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text("当前数据已同步", style: TextStyle(color: Colors.black45,)),
              )
            ],
          )
        );
      }
    );
  }
}

// 列表
class Lists extends StatefulWidget {
  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  var a = 0;

  @override
  Widget build(BuildContext context) {
    initList(context, "0");    
    return Provide<ItemList>(
      builder: (context, child, counter) {
        var data = counter.items;
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
            border: new Border.all(width: 1.0, color: toColor('#EEF0F2')),
          ),
          margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
          child: data.length != 0 ? Container(
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true, 
              padding: const EdgeInsets.all(3.0),
              itemCount:  data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListsItem(data: data[index], cate: 0, index: index);
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black12, height: 6),
            ),
          )
          : Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("当前列表中没有任务，请点击正下方的 + 号按钮创建吧！")
          ),
        );
      }
    );
  }
}

// 任务列表项
class ListsItem extends StatefulWidget {
  ListsItem({Key key, this.data, this.cate, this.index}) : super(key: key);
  final data;
  final cate;
  final index;

  @override
  _ListsItemState createState() => _ListsItemState();
}

class _ListsItemState extends State<ListsItem> {
  var complete = "0";
  var im = "0";
  bool content = false;

  @override
  void initState() {
    complete = this.widget.data["complete"];
    im = this.widget.data["im"];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material( 
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // switch(this.widget.cate) {
          //   case 0:
          //     // 今日任务
          //     Navigator.push(context, SlideRightRoute(page: new ListsItemContent(index: this.widget.index, cate: this.widget.cate)));
          //     break;
          //   case 1:
          //     // 娱乐
          //     Navigator.push(context, SlideRightRoute(page: new ListsItemContent(index: this.widget.index, cate: this.widget.cate)));
          //     break;
          //   case 3:
          //     // 月计划
          //     Navigator.push(context, SlideRightRoute(page: new ListsItemContentMonth(index: this.widget.index, cate: this.widget.cate)));
          //     break;
          //   case 4:
          //     // 年计划
          //     Navigator.push(context, SlideRightRoute(page: new ListsItemContentYear(index: this.widget.index, cate: this.widget.cate)));
          //     break;
          //   default:
          //     break;
          // }
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 2.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: (){
                  setState(() {
                    complete = complete == "1" ? "0" : "1";
                    itemComplete(context, this.widget.cate, this.widget.index, complete);
                    // Provide.value<ItemList>(context).changeComplete(index, complete);
                    // switch(this.widget.cate) {
                    //   case 0:
                    //     // 今日任务
                    //     Provide.value<ItemList>(context).changeComplete(index, complete);
                    //     break;
                    //   case 1:
                    //     // 娱乐
                    //     Provide.value<PlayList>(context).changeComplete(index, complete);
                    //     break;
                    //   case 3:
                    //     // 月计划
                    //     Provide.value<ItemListMonth>(context).changeComplete(index, complete);
                    //     break;
                    //   case 4:
                    //     // 年计划
                    //     Provide.value<ItemListYear>(context).changeComplete(index, complete);
                    //     break;
                    //   default:
                    //     break;
                    // }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: complete == "1" ? Icon(Icons.check_box, color: Colors.green, size: 25.0) 
                    : Icon(Icons.check_box_outline_blank, color: toColor("#8c8c8c"), size: 25.0),
                ),
              ),
              Expanded(
                child: Text(this.widget.data["title"], 
                  style: complete == "1" ? TextStyle(fontSize: 15.0, decoration: TextDecoration.lineThrough, color: toColor('#8c8c8c')) 
                    : TextStyle(fontSize: 15.0),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    im = im == "1" ? "0" : "1";
                    // switch(this.widget.cate) {
                    //   case 0:
                    //     // 今日任务
                    //     // Provide.value<ItemList>(context).changeCollect(index, collect);
                    //     break;
                    //   case 1:
                    //     // 娱乐
                    //     Provide.value<PlayList>(context).changeCollect(index, collect);
                    //     break;
                    //   case 3:
                    //     // 月计划
                    //     Provide.value<ItemListMonth>(context).changeCollect(index, collect);
                    //     break;
                    //   case 4:
                    //     // 年计划
                    //     Provide.value<ItemListYear>(context).changeCollect(index, collect);
                    //     break;
                    //   default:
                    //     break;
                    // }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: im == "1" ? Icon(Icons.star, color: Colors.blue, size: 25.0) : 
                  Icon(Icons.star_border, color: toColor("#8c8c8c"), size: 25.0),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}