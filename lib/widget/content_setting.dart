import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/ajax_models.dart';
import '../config/config.dart';

// 设置
class Setting extends StatefulWidget {
  Setting({Key key, this.index, this.cate, this.heart}) : super(key: key);
  final int index;
  final String cate;
  final int heart;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int h = 1;

  @override
  void initState() {
    h = this.widget.heart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 11.0, right: 11.0),
      child: ListView(
        children: <Widget>[
          Text(this.widget.cate == 0 ? "选择完成本任务后奖励的心心数" : "选择完成本娱乐后消费的心心数",
            style: TextStyle(
              color: toColor('#8c8c8c'),
              fontSize: 14.0,
            ),
          ),
          Container(
            height: 50,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: heartChip.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, //每行三列
                childAspectRatio: 0.6, //显示区域宽高相等
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ChoiceChip(
                  backgroundColor: toColor('#e8e8e8'),
                  avatar: CircleAvatar(
                    backgroundColor: toColor('#e8e8e8'),
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                  label: Text(heartChip[index]["name"]),
                  selected: h == heartChip[index]["value"],
                  onSelected: (bool selected) {
                    setState(() {
                      h = heartChip[index]["value"];
                      itemHeart(context, this.widget.cate, this.widget.index, h);
                    });
                  },
                );
              }
            )
          ),
        ],
      ),
    );
  }
}