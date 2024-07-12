import 'dart:async';

import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../commponts/Color.dart';
import '../commponts/UserBill.dart';
import '../commponts/draw.dart';


GlobalKey<_BillState> BillKey = GlobalKey();

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

rangeDateChange(DateTime date) {}

class _BillState extends State<Bill> {
  final Storage = GetStorage();
  bool showweekdata = true;
  double totalweekprice = 0;
  double maxweekprice = 0.9;
  var weekdata = [];
  late List mouthdata = [];
  // 数据
  Map billdata = Map();
  @override
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Storage.write("mouthDate", date);
    });
    print(Storage.read("mouthDate"));
    print(111);
    if (Storage.read("isCreatedb") == null) {
      onCreate();
      Storage.write("isCreatedb", true);
    }
    // billdata[1] = "Bush";
    getweekdata();
    getdata(DateTime.now());
    // TODO: implement initState
    super.initState();
  }

// 获取本周的数据
  getweekdata() async {
    Future<List> list = getWeekData();
    weekdata = await list;
    for (int i = 0; i < weekdata.length; i++) {
      if (weekdata[i] != 0) {
        weekdata[i] = -weekdata[i];
      }
      totalweekprice += weekdata[i];
      if (weekdata[i] > maxweekprice) {
        maxweekprice = weekdata[i] + 10;
      }
    }

    print(weekdata);
    print(totalweekprice);
    setState(() {});
  }

//初始化数据
  getdata(DateTime now) async {
    if (now.toString().substring(0, 7) == DateTime.now().toString().substring(0, 7)) {
      showweekdata = true;
    }
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    print(monthStart);
    print(monthEnd);
    Future<List> list = getUserBillsByDateRange(monthStart, monthEnd);
    mouthdata = await list;
    // mouthdata.forEach((item) {
    //   item["data"].forEach((items) {
    //     print(items);
    //     items as Widget;
    //   });
    // });
    print(mouthdata);
    setState(() {});
  }

// 根据日期获取day
  getday(String data) {
    return data.substring(6, 10);
  }

  // 根据日期获取week
  getweek(String data) {
    var date = DateTime.parse(data);
    print(date.weekday.runtimeType);
    switch (date.weekday) {
      case 1:
        return "星期一";
      case 2:
        return "星期二";
      case 3:
        return "星期三";
      case 4:
        return "星期四";
      case 5:
        return "星期五";
      case 6:
        return "星期六";
      case 7:
        return "星期日";
    }
  }

  // 日期
  String date = DateTime.now().toString().substring(0, 7);
  rangeDateChange(DateTime date) {}
  changgeDate() {
    BrnDatePicker.showDatePicker(context,
        initialDateTime: DateTime.parse(date + "-01"),
        // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
        // pickerMode: BrnDateTimePickerMode.date,
        // minuteDivider: 30,
        pickerTitleConfig: BrnPickerTitleConfig.Default,
        dateFormat: 'yyyy年,MMMM月', onConfirm: (dateTime, list) {
      if (dateTime.toString().substring(0, 7) != date) {
        date = dateTime.toString().substring(0, 7);
        showweekdata = false;
        getdata(DateTime.parse(date + "-01"));
        getweekdata();
        Storage.write("mouthDate", date);
      }
      if (dateTime.toString().substring(0, 7) == DateTime.now().toString().substring(0, 7)) {}
      setState(() {});
    }, onClose: () {
      print("onClose");
    }, onCancel: () {
      print("onCancel");
    }, onChange: (dateTime, list) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
        brightness: Brightness.light,
        showDefaultBottom: true,
        leading: Builder(
          builder: (context) {
            return Container(
                padding: EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset(
                    'resources/image/hometable/menu.png',
                    width: 25,
                    height: 25,
                  ),
                ));
          },
        ),
        //自定义左侧icon
        // 中间标题
        title: InkWell(
          onTap: changgeDate,
          child: Text(
            date,
            style: TextStyle(color: Colors.black),
          ),
        ),
        // 右测icon
        actions: [
          Container(
            child: InkWell(
              splashColor: Colors.blue,
              onTap: () async {
                var data = await Get.toNamed("/calendarPage");
                getdata(DateTime.parse(Storage.read("mouthDate") + "-01"));
              },
              child: Image.asset(
                'resources/image/hometable/date.png',
                width: 23,
                height: 23,
              ),
            ),
          ),
          Container(
            child: InkWell(
              splashColor: Colors.blue,
              onTap: () {
                Get.toNamed("/totalYearOrMouth");
              },
              child: Image.asset(
                'resources/image/hometable/echart.png',
                width: 23,
                height: 23,
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      drawer: Draw(),
      body: Container(
          // alignment: Alignment.center,
          // color: Colors.amber,
          width: double.infinity,
          height: double.infinity,
          child: mouthdata.length != 0
              ? Container(
                  color: baColor,
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                        ),
                        padding: showweekdata == false ? null : EdgeInsets.all(20),
                        child: showweekdata == false
                            ? null
                            : Column(
                                children: [
                                  Container(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "本周支出",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                              ),
                                              Text("共计:" + totalweekprice.toString() + "元")
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            color: Colors.blue.shade400,
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_drop_down_circle_outlined),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: BrnBrokenLine(
                                      xyDialLineWidth: 0,
                                      dialWidth: 8,
                                      showPointDashLine: false,
                                      xDialMax: 6,
                                      xDialMin: 0,
                                      xDialColor: Color(0xFF999999),
                                      xDialValues: [
                                        BrnDialItem(
                                          value: 0,
                                          dialText: '周一',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 1,
                                          dialText: '周二',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 2,
                                          dialText: '周三',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 3,
                                          dialText: '周四',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 4,
                                          dialText: '周五',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 5,
                                          dialText: '周六',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                        BrnDialItem(
                                          value: 6,
                                          dialText: '周日',
                                          dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                        ),
                                      ],
                                      isShowYDialText: true,
                                      yDialMax: maxweekprice,
                                      yDialMin: 0,
                                      lines: [
                                        BrnPointsLine(
                                          isShowXDial: true,
                                          isShowPointText: true,
                                          lineWidth: 3,
                                          pointRadius: 4,
                                          isShowPoint: true,
                                          isCurve: true,
                                          points: weekdata.length == 0
                                              ? []
                                              : [
                                                  BrnPointData(
                                                      pointText: weekdata[0].toString(),
                                                      y: weekdata[0],
                                                      x: 0,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[1].toString(),
                                                      y: weekdata[1],
                                                      x: 1,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[2].toString(),
                                                      y: weekdata[2],
                                                      x: 2,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[3].toString(),
                                                      y: weekdata[3],
                                                      x: 3,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[4].toString(),
                                                      y: weekdata[4],
                                                      x: 4,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[5].toString(),
                                                      y: weekdata[5],
                                                      x: 5,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                  BrnPointData(
                                                      pointText: weekdata[6].toString(),
                                                      y: weekdata[6],
                                                      x: 6,
                                                      lineTouchData: BrnLineTouchData(
                                                        tipWindowSize: Size(60, 40),
                                                      )),
                                                ],
                                          shaderColors: [Colors.green.withOpacity(0.3), Colors.green.withOpacity(0.01)],
                                          lineColor: Colors.green,
                                        )
                                      ],
                                      size: Size(300, 150),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Container(
                          child: Column(
                        children: mouthdata.map((item) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70,
                            ),
                            // padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 15),
                            child: item["data"].length == 0
                                ? null
                                : Column(
                                    children: [
                                      Container(
                                        height: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              padding: EdgeInsets.only(left: 15),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                getday(item["time"]) + " " + getweek(item["time"]),
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              padding: EdgeInsets.only(right: 15),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                item["totalDayPrice"].toString() + "元",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: item["data"].map<Widget>((items) {
                                          return Container(
                                              height: 70,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                                              child: Slidable(
                                                key: ValueKey('$items["dateTime"]'),
                                                endActionPane: ActionPane(
                                                  motion: ScrollMotion(),
                                                  dismissible: DismissiblePane(onDismissed: () {
                                                    for (int i = 0; i < item["data"].length; i++) {
                                                      if (item["data"][i]["id"] == items["id"]) {
                                                        print(item["data"][i]["id"]);
                                                        item["data"].remove(items);
                                                        if (items["price"] < 0) {
                                                          totalweekprice = totalweekprice + items["price"];
                                                        }
                                                        item["totalDayPrice"] = item["totalDayPrice"] - items["price"];
                                                        print(mouthdata);
                                                      }
                                                    }

                                                    deleteUserBill(items["id"]);
                                                    getweekdata();
                                                    setState(() {});
                                                  }), //滑动触发的事件
                                                  children: [
                                                    SlidableAction(
                                                      // An action can be bigger than the others.
                                                      flex: 2,
                                                      onPressed: (BuildContext context) {},
                                                      backgroundColor: Color(0xFF7BC043),
                                                      foregroundColor: Colors.white,
                                                      // icon: Icons.topic_sharp,
                                                      label: '修改',
                                                    ),
                                                    SlidableAction(
                                                      flex: 2,
                                                      onPressed: (BuildContext context) {
                                                        print(item.length);
                                                        for (int i = 0; i < item["data"].length; i++) {
                                                          if (item["data"][i]["id"] == items["id"]) {
                                                            print(item["data"][i]["id"]);
                                                            item["data"].remove(items);
                                                            if (items["price"] < 0) {
                                                              totalweekprice = totalweekprice + items["price"];
                                                            }
                                                            item["totalDayPrice"] =
                                                                item["totalDayPrice"] - items["price"];
                                                          }
                                                        }

                                                        deleteUserBill(items["id"]);
                                                        getweekdata();
                                                        setState(() {});
                                                        // deleteUserBill(items["id"]);
                                                        print(items["id"].runtimeType);
                                                      },
                                                      backgroundColor: Color(0xFFFE4A49),
                                                      foregroundColor: Colors.white,
                                                      icon: Icons.delete,
                                                      label: '删除',
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  splashColor: Colors.blue,
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                        padding: EdgeInsets.only(left: 15),
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(right: 10),
                                                              width: 5,
                                                              height: 5,
                                                              decoration: BoxDecoration(
                                                                color: Colors.red.shade400,
                                                                borderRadius: BorderRadius.circular(100),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              child: items["othertext"] == ""
                                                                  ? Text(items["title"])
                                                                  : Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          items["title"],
                                                                          style: TextStyle(fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          items["othertext"],
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: Colors.grey.shade400),
                                                                        )
                                                                      ],
                                                                    ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        padding: EdgeInsets.only(right: 15),
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          items["price"].toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: items["price"] > 0
                                                                  ? Colors.green
                                                                  : Colors.red.shade400),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        }).toList(),
                                      )
                                    ],
                                  ),
                          );
                        }).toList(),
                      )),
                    ],
                  ),
                )
              : BrnAbnormalStateWidget(
                  img: Image.asset(
                    'resources/image/bill/none.png',
                    scale: 3.0,
                  ),
                  content: "本月暂无账单",
                  isCenterVertical: true,
                )),
    );
  }
}
