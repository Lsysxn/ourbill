
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commponts/Color.dart';
import '../commponts/UserBill.dart';
import '../commponts/alldata.dart';

class totalYearOrMouth extends StatefulWidget {
  const totalYearOrMouth({super.key});

  @override
  State<totalYearOrMouth> createState() => _totalYearOrMouthState();
}

class _totalYearOrMouthState extends State<totalYearOrMouth> {
  var showdata = false;
  var type = 0; //0是支出，1是收入
  double totalmouthprice = 0;
  double maxmouthprice = 0.9;
  var linedata = [];
  var mouthdata = [];
  var mouthtypelist = [];
  @override
  void initState() {
    // TODO: implement initState
    getdata(type);
    super.initState();
  }

  getdata(type) async {
    if (activeflag == "mouth") {
      Future<List> list = getmouthtotal(DateTime.parse(date + "-01"));
      mouthdata = await list;
      totalmouthprice = 0;
      for (int i = 0; i < mouthdata.length; i++) {
        print(mouthdata[i]["paytotalDayPrice"].runtimeType);
        totalmouthprice += mouthdata[i]["totalDayPrice"];
        if ((-mouthdata[i]["paytotalDayPrice"]) > maxmouthprice) {
          maxmouthprice = (-mouthdata[i]["paytotalDayPrice"]) + 1;
        }
      }
      print(mouthdata);
      Future<List> typelist = gettotalmouthBytype(DateTime.parse(date + "-01"), type);
      mouthtypelist = await typelist;

      setState(() {});
    } else {
      totalmouthprice = 0;
      Future<List> list = getyeartotal(DateTime.parse(date + "-01" + "-01"));
      mouthdata = await list;
      for (int i = 0; i < mouthdata.length; i++) {
        totalmouthprice += mouthdata[i]["totalDayPrice"];
        if ((-mouthdata[i]["paymouthPrice"]) > maxmouthprice) {
          maxmouthprice = (-mouthdata[i]["paymouthPrice"]) + 1;
        }
      }

      Future<List> typelist = gettotalyeartBytype(DateTime.parse(date + "-01" + "-01"), type);
      mouthtypelist = await typelist;
      setState(() {});
    }
  }

  getmouthDays() {
    if (activeflag == "mouth") {
      var monthEnd =
          DateTime(DateTime.parse(date + "-01").year, DateTime.parse(date + "-01").month + 1, 0, 23, 59, 59).day;
      return monthEnd - 1;
    } else {
      return 12;
    }
  }

  // 日期
  String date = DateTime.now().toString().substring(0, 7);
  changgeDate() {
    if (activeflag == "mouth") {
      BrnDatePicker.showDatePicker(context,
          initialDateTime: DateTime.parse(date + "-01"),
          // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
          // pickerMode: BrnDateTimePickerMode.date,
          // minuteDivider: 30,
          pickerTitleConfig: BrnPickerTitleConfig.Default,
          dateFormat: 'yyyy年,MMMM月', onConfirm: (dateTime, list) {
        date = dateTime.toString().substring(0, 7);
        getdata(type);
        setState(() {});
      });
    } else {
      BrnDatePicker.showDatePicker(context,
          initialDateTime: DateTime.parse(date + "-01" + "-01"),
          // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
          // pickerMode: BrnDateTimePickerMode.date,
          // minuteDivider: 30,
          pickerTitleConfig: BrnPickerTitleConfig.Default,
          dateFormat: 'yyyy年', onConfirm: (dateTime, list) {
        print(dateTime);
        date = dateTime.toString().substring(0, 4);
        getdata(type);
        setState(() {});
      });
    }
  }

  add() {
    if (activeflag == "mouth") {
      var mouth = DateTime.parse(date + "-01").month;
      var newmouth = "";
      if (mouth == 12) {
        newmouth = "01";
      } else {
        mouth = mouth + 1;
        if (mouth < 10) {
          newmouth = "0" + mouth.toString();
        } else {
          newmouth = mouth.toString();
        }
      }
      date = DateTime.parse(date + "-01").year.toString() + "-" + newmouth;
    } else {
      date = (int.parse(date) + 1).toString();
    }
    getdata(type);
    setState(() {});
  }

  reduce() {
    if (activeflag == "mouth") {
      var mouth = DateTime.parse(date + "-01").month;
      var newmouth = "";
      if (mouth == 1) {
        newmouth = "12";
      } else {
        mouth = mouth - 1;
        if (mouth < 10) {
          newmouth = "0" + mouth.toString();
        } else {
          newmouth = mouth.toString();
        }
      }
      date = DateTime.parse(date + "-01").year.toString() + "-" + newmouth;
    } else {
      date = (int.parse(date) - 1).toString();
    }
    getdata(type);
    setState(() {});
  }

  // 激活状态
  var activeflag = "mouth";
  changgeactiveflga(flag) {
    if (flag == activeflag) {
      return;
    }
    activeflag = flag;
    if (flag == "mouth") {
      date = date + "-01";
    } else {
      date = date.substring(0, 4);
    }
    getdata(type);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
        title: Container(
          padding: EdgeInsets.all(3),
          width: 100,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color.fromRGBO(238, 238, 239, 1),
          ),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () => changgeactiveflga("mouth"),
                child: Container(
                  decoration: activeflag == "mouth"
                      ? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))
                      : null,
                  alignment: Alignment.center,
                  child: Text(
                    "月",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () => changgeactiveflga("year"),
                child: Container(
                  decoration: activeflag == "year"
                      ? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))
                      : null,
                  alignment: Alignment.center,
                  child: Text(
                    "年",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      body: Container(
        color: baColor,
        child: mouthdata.length == 0
            ? Container(
                color: Colors.amber,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            child: InkWell(
                              splashColor: Colors.blue,
                              onTap: reduce,
                              child: Icon(Icons.chevron_left_outlined),
                            ),
                          ),
                          InkWell(
                            onTap: changgeDate,
                            child: Container(
                              alignment: Alignment.center,
                              width: 80,
                              child: Text(date),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: InkWell(
                              splashColor: Colors.blue,
                              onTap: add,
                              child: Icon(Icons.chevron_right_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: BrnAbnormalStateWidget(
                        img: Image.asset(
                          'resources/image/bill/none.png',
                          scale: 3.0,
                        ),
                        content: activeflag == "mouth" ? '本月暂无账单' : "本年暂无账单",
                        isCenterVertical: true,
                      ),
                    ))
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: InkWell(
                            splashColor: Colors.blue,
                            onTap: reduce,
                            child: Icon(Icons.chevron_left_outlined),
                          ),
                        ),
                        InkWell(
                          onTap: changgeDate,
                          child: Container(
                            alignment: Alignment.center,
                            width: 80,
                            child: Text(date),
                          ),
                        ),
                        Container(
                          width: 50,
                          child: InkWell(
                            splashColor: Colors.blue,
                            onTap: add,
                            child: Icon(Icons.chevron_right_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 折线图
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "日收支统计",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: BrnBrokenLine(
                                xyDialLineWidth: 0,
                                dialWidth: 8,
                                showPointDashLine: false,
                                xDialMax: getmouthDays().toDouble(),
                                xDialMin: 0,
                                xDialColor: Colors.amber,
                                xDialValues: mouthdata.map((item) {
                                  return BrnDialItem(
                                    value: item["index"].toDouble(),
                                    // dialText: item["index"].toString(),
                                    dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
                                  );
                                }).toList(),
                                isShowYDialText: true,
                                yDialMax: maxmouthprice,
                                yDialMin: 0,
                                lines: [
                                  BrnPointsLine(
                                    isShowXDial: true,
                                    isShowPointText: true,
                                    lineWidth: 3,
                                    pointRadius: 4,
                                    isShowPoint: true,
                                    isCurve: true,
                                    points: mouthdata.map((items) {
                                      double price = 0;
                                      if (items["paytotalDayPrice"] != null) {
                                        if (items["paytotalDayPrice"].toDouble() != 0) {
                                          price = -items["paytotalDayPrice"];
                                        }
                                      } else {
                                        if (items["paymouthPrice"].toDouble() != 0) {
                                          price = -items["paymouthPrice"];
                                        }
                                      }
                                      return BrnPointData(
                                          // pointText: '88',
                                          y: price,
                                          x: items["index"].toDouble(),
                                          lineTouchData: BrnLineTouchData(
                                            tipWindowSize: Size(60, 40),
                                          ));
                                    }).toList(),
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
                      // 分类统计
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                          padding: EdgeInsets.only(top: 15, bottom: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "分类统计",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      padding: EdgeInsets.all(3),
                                      width: 100,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color.fromRGBO(238, 238, 239, 1),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              type = 0;
                                              getdata(type);
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: type == 0
                                                  ? BoxDecoration(
                                                      color: Colors.white, borderRadius: BorderRadius.circular(4))
                                                  : null,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "支出",
                                                style: TextStyle(color: Colors.black, fontSize: 13),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {
                                              type = 1;
                                              getdata(type);
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: type == 1
                                                  ? BoxDecoration(
                                                      color: Colors.white, borderRadius: BorderRadius.circular(4))
                                                  : null,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "收入",
                                                style: TextStyle(color: Colors.black, fontSize: 13),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    mouthtypelist.length == 0
                                        ? Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: BrnAbnormalStateWidget(
                                              img: Image.asset(
                                                'resources/image/bill/none.png',
                                                scale: 3.0,
                                              ),
                                              content: type == 0 ? '暂无支出' : "暂无收入",
                                              isCenterVertical: true,
                                            ),
                                          )
                                        : BrnDoughnutChart(
                                            ringWidth: 30,
                                            padding: EdgeInsets.all(50),
                                            // data: [
                                            //   BrnDoughnutDataItem(value: 10, title: "三餐"),
                                            //   BrnDoughnutDataItem(value: 8, title: "零食", color: Colors.green)
                                            // ],
                                            data: mouthtypelist.map((item) {
                                              return BrnDoughnutDataItem(
                                                value: item["totalDayPrice"],
                                                title: item["title"],
                                                color: typeColorlist[item["title"]] as Color,
                                              );
                                            }).toList(),
                                            width: 350,
                                            height: 150,
                                          )
                                  ],
                                ),
                              ),
                              Column(
                                children: mouthtypelist.map((item) {
                                  return Container(
                                    height: 80,
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          typeIconlist[item["title"]] as String,
                                          width: 25,
                                          height: 25,
                                          color: typeColorlist[item["title"]],
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            height: 60,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                item["title"],
                                                                style: TextStyle(fontWeight: FontWeight.w500),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                (item["totalDayPrice"] / item["totalmouthPrice"] * 100)
                                                                        .toStringAsFixed(2) +
                                                                    "%",
                                                                style: TextStyle(
                                                                    fontSize: 13, color: Colors.grey.shade400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(item["totalDayPrice"].toString()),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                LinearProgressIndicator(
                                                  backgroundColor: Colors.grey.shade400,
                                                  color: typeColorlist[item["title"]] as Color,
                                                  value: item["totalDayPrice"] / item["totalmouthPrice"],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                      // 日报表和年报表
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 25),
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                activeflag == "mouth" ? "日报表" : "月报表",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: activeflag == "mouth"
                                  ? Text(
                                      "平均每日支出:" + (totalmouthprice / mouthdata.length).toStringAsFixed(2) + "元",
                                      style: TextStyle(color: greyColor),
                                    )
                                  : Text(
                                      "平均每月支出:" + (totalmouthprice / 12).toStringAsFixed(2) + "元",
                                      style: TextStyle(color: greyColor),
                                    ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "日期",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "收入",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "支出",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "结余",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Column(
                                children: mouthdata.map((item) {
                              return Container(
                                child: item["totalDayPrice"] == 0
                                    ? null
                                    : Container(
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                activeflag == "mouth"
                                                    ? item["date"].toString().substring(0, 10)
                                                    : (item["date"].year).toString() +
                                                        "年" +
                                                        (item["date"].month).toString() +
                                                        "月",
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                activeflag == "mouth"
                                                    ? item["incometotalDayPrice"].toString()
                                                    : item["incomemouthPrice"].toString(),
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                activeflag == "mouth"
                                                    ? item["paytotalDayPrice"].toString()
                                                    : item["paymouthPrice"].toString(),
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                activeflag == "mouth"
                                                    ? item["totalDayPrice"].toString()
                                                    : item["totalDayPrice"].toString(),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                              );
                            }).toList())
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
      ),
    );
  }
}
