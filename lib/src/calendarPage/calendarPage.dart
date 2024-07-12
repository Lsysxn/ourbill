

import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

import '../commponts/Color.dart';
import '../commponts/UserBill.dart';

class alendarpage extends StatefulWidget {
  const alendarpage({super.key});

  @override
  State<alendarpage> createState() => _alendarpageState();
}

class _alendarpageState extends State<alendarpage> {
  void initState() {
    // TODO: implement initState
    focusedday = DateTime.now();
    print(focusedday);
    getdata(DateTime.now());
    super.initState();
  }

  double totalmouthPrice = 0;
  double paymouthPrice = 0;
  double incomemouthPrice = 0;
  var foucoousdata = null;
  DateTime now = DateTime.now(); // 获取当前日期时间
  var showtaday = true;
  var focusedday;
  List mouthdata = [];
  @override

//初始化数据
  getdata(DateTime now) async {
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    print(monthStart);
    print(monthEnd);
    Future<List> list = getUserBillsByDateRange(monthStart, monthEnd);

    mouthdata = await list;
    if (mouthdata.length > 0) {
      totalmouthPrice = mouthdata[0]["totalmouthPrice"];
      paymouthPrice = mouthdata[0]["paymouthPrice"];
      incomemouthPrice = mouthdata[0]["incomemouthPrice"];
    } else {
      foucoousdata = null;
      totalmouthPrice = 0;
      paymouthPrice = 0;
      incomemouthPrice = 0;
    }
    print(mouthdata);
    print("mouthdata");
    for (int i = 0; i < mouthdata.length; i++) {
      if (focusedday.toString().substring(0, 10) == mouthdata[i]["time"].toString().substring(0, 10)) {
        foucoousdata = mouthdata[i];
        setState(() {});
        print(foucoousdata);
        break;
      } else {
        if (i == mouthdata.length - 1) {
          foucoousdata = null;
        }
      }
    }
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

  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
        title: "日历视图",
      ),
      body: Container(
          color: baColor,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: Column(
                    children: [
                      TableCalendar(
                          onPageChanged: (day) {
                            setState(() {
                              print(day);
                              focusedday = day;
                              getdata(day);
                            });
                          },
                          rowHeight: 70,
                          rangeStartDay: focusedday,
                          rangeEndDay: focusedday,
                          onDaySelected: (day, days) {
                            setState(() {
                              focusedday = days;
                              for (int i = 0; i < mouthdata.length; i++) {
                                if (days.toString().substring(0, 10) ==
                                    mouthdata[i]["time"].toString().substring(0, 10)) {
                                  foucoousdata = mouthdata[i];
                                  setState(() {});
                                  print(foucoousdata);
                                  return;
                                }
                              }
                              foucoousdata = null;
                            });
                          },
                          calendarBuilders: CalendarBuilders(
                            weekNumberBuilder: (context, weekNumber) {},
                            markerBuilder: (context, day, dasy) {
                              for (int i = 0; i < mouthdata.length; i++) {
                                if (day.toString().substring(0, 10) ==
                                    mouthdata[i]["time"].toString().substring(0, 10)) {
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        mouthdata[i]["totalDayPrice"].toString(),
                                        style: TextStyle(
                                            color: mouthdata[i]["totalDayPrice"] > 0 ? Colors.green : Colors.red,
                                            fontSize: 12),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          daysOfWeekVisible: true,
                          locale: 'zh_CN',
                          firstDay: DateTime.utc(2000, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: focusedday,
                          headerStyle: const HeaderStyle(
                            titleCentered: true,
                            leftChevronVisible: true,
                            rightChevronVisible: true,
                            formatButtonVisible: false,
                          ),
                          calendarStyle: const CalendarStyle(
                            markersMaxCount: 1,
                            canMarkersOverflow: true,
                            isTodayHighlighted: true,
                            outsideDaysVisible: false,
                            cellPadding: EdgeInsets.only(bottom: 15),
                            rangeStartDecoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            todayTextStyle: TextStyle(color: Colors.black),
                            todayDecoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            markerSizeScale: 5,
                          )),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "月收入",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  incomemouthPrice.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "月支出",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  paymouthPrice.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "月结余",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  totalmouthPrice.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: foucoousdata == null
                    ? null
                    : Column(
                        children: [
                          Container(
                            child: Container(
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
                                      getday(foucoousdata["time"]) + " " + getweek(foucoousdata["time"]),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(right: 15),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      foucoousdata["totalDayPrice"].toString() + "元",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView(
                            children: foucoousdata["data"].map<Widget>((items) {
                              return Container(
                                  height: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                                  child: Slidable(
                                    key: ValueKey('$items["dateTime"]'),
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      dismissible: DismissiblePane(onDismissed: () {
                                        for (int i = 0; i < foucoousdata["data"].length; i++) {
                                          if (foucoousdata["data"][i]["id"] == items["id"]) {
                                            if (items["price"] > 0) {
                                              print(111);
                                              incomemouthPrice = incomemouthPrice - items["price"];
                                            } else {
                                              print(222);
                                              paymouthPrice = paymouthPrice - items["price"];
                                            }
                                            totalmouthPrice = totalmouthPrice - items["price"];
                                            print(foucoousdata["data"][i]["id"]);
                                            foucoousdata["data"].remove(items);
                                            foucoousdata["totalDayPrice"] =
                                                foucoousdata["totalDayPrice"] - items["price"];
                                          }
                                        }

                                        deleteUserBill(items["id"]);
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
                                            print(foucoousdata.length);
                                            for (int i = 0; i < foucoousdata["data"].length; i++) {
                                              if (foucoousdata["data"][i]["id"] == items["id"]) {
                                                print(foucoousdata["data"][i]["id"]);
                                                print(items["price"].runtimeType);

                                                if (items["price"] > 0) {
                                                  print(111);
                                                  incomemouthPrice = incomemouthPrice - items["price"];
                                                } else {
                                                  print(222);
                                                  paymouthPrice = paymouthPrice - items["price"];
                                                }
                                                totalmouthPrice = totalmouthPrice - items["price"];
                                                foucoousdata["data"].remove(items);
                                                foucoousdata["totalDayPrice"] =
                                                    foucoousdata["totalDayPrice"] - items["price"];
                                              }
                                            }
                                            deleteUserBill(items["id"]);
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
                                                              style:
                                                                  TextStyle(fontSize: 13, color: Colors.grey.shade400),
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
                                                  color: items["price"] > 0 ? Colors.green : Colors.red.shade400),
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ))
                        ],
                      ),
              ))
            ],
          )),
    );
  }
}

