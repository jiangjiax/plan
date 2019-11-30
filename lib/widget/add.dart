import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../models/ajax_models.dart';
import '../config/config.dart';
import 'package:provide/provide.dart';
import '../provide/provide.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var pagecate = 0;

  @override
  Widget build(BuildContext context) {
    return Provide<ColorData>(
      builder: (context, child, counter) {
        var title = "今日任务";
        switch(counter.pagecate) {
          case 1:
            // 创建娱乐
            title = "今日娱乐/休息";
            break;
          case 2:
            // 创建明日规划
            break;
          case 3:
            // 月计划
            break;
          case 4:
            // 年计划
            break;
          default:
            break;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            title: Text(title + "创建", style: TextStyle(color: Colors.black))
          ),
          body: new Container(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 10.0, right: 12.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true, 
              children: <Widget>[
                FromItem(cate: counter.pagecate.toString()),
              ]
            )
          ),
        );
      }
    );
  }
}

// 表单
class FromItem extends StatefulWidget {
  FromItem({Key key, this.cate}) : super(key: key);
  final cate;

  @override
  _FromItemState createState() => _FromItemState();
}

class _FromItemState extends State<FromItem> {
  int heart = 1;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Form(
        key: _formKey, //设置globalKey，用于后面获取FormState
        // autovalidate: true, //开启自动校验
        child: new ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true, 
          children: <Widget>[
            TextFormField(
              minLines: 1,
              maxLines: 2,
              autofocus: true,
              controller: _titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: '标题',
                labelStyle: TextStyle(fontSize: 15.0),
              ),
              validator: (v) {
                return v
                  .trim()
                  .length > 0 ? null : "标题不能为空";
              }
            ),
            TextFormField(
              maxLength: 80,
              minLines: 2,
              maxLines: null,
              controller: _noteController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: '备注',
                labelStyle: TextStyle(fontSize: 15.0),
              ),
              // validator: (v) {
              //   return v
              //     .trim()
              //     .length > 0 ? null : "备注不能为空";
              // }
            ),
            Padding(padding: const EdgeInsets.only(top: 5.0),),
            this.widget.cate != 3 && this.widget.cate != 4 ? 
            Text(this.widget.cate == 0 ? "选择完成本任务后奖励的心心数" : "选择完成本娱乐后消费的心心数",
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5,  
                color: toColor('#8c8c8c')
              ),
            )  : Container(margin: EdgeInsets.only(top: 5.0)),
            Container(
              height: 50,
              padding: const EdgeInsets.only(top: 2.0),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: heartChip.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, //每行三列
                  childAspectRatio: 0.6, //显示区域宽高相等
                  mainAxisSpacing: 2.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ChoiceChip(
                    backgroundColor: toColor('#e8e8e8'),
                    avatar: CircleAvatar(
                      backgroundColor: toColor('#e8e8e8'),
                      child: Icon(Icons.favorite, color: Colors.red),
                    ),
                    label: Text(heartChip[index]["name"]),
                    selected: heart == heartChip[index]["value"],
                    onSelected: (bool selected) {
                      setState(() {
                        heart = heartChip[index]["value"];
                      });
                    },
                  );
                }
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 14.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: Colors.blue,
                child: Text('创建', style: TextStyle(color: Colors.white, letterSpacing: 1)),
                onPressed: () {
                  if((_formKey.currentState as FormState).validate()){
                    //验证通过提交数据
                    String title = _titleController.text;
                    String note = _noteController.text;
                    itemAdd(context, this.widget.cate, title, heart, note);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ]
        )
      )
    );
  }
}