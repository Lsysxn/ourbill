import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'alldata.dart';


class UserBill {
  // 日期
  final DateTime dateTime;
  // 类型 支出还是收入
  final String type;
  // 价格
  final double price;
  // 种类
  final String title;
  // 备注
  final String othertext;
//  构造函数
  UserBill(this.type, this.price, this.title, this.othertext, this.dateTime);
}

initDataBase() async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Future<sql.Database> database = sql.openDatabase(path);
  print("数据库打开了");
  // onCreate();
}

Future<void> closeDatabase() async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  // print(db.close());
  print("数据库关闭了");
  await db.close();
  // var list = getall();
  // var mouthdata = await list;
  // print(mouthdata);
}

Future<void> onCreate() async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  // 在数据库创建时运行的 SQL 语句
  await db.execute(
    'CREATE TABLE UserBill (id INTEGER PRIMARY KEY AUTOINCREMENT, dateTime DateTime, type TEXT, price Double, title TEXT, othertext TEXT)',
  );
}

Future<void> deleteUserBill(int id) async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');

  Database db = await openDatabase(path);
  await db.delete('UserBill', where: 'id = ?', whereArgs: [id]);
}

Future<void> addUserBill(UserBill userBill) async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');

  Database db = await openDatabase(path);
  await db.execute('INSERT INTO UserBill (dateTime, type, price, title, othertext) VALUES (?, ?, ?, ?, ?)', [
    userBill.dateTime.toIso8601String(),
    userBill.type,
    userBill.price,
    userBill.title,
    userBill.othertext,
  ]);
}

Future<List> getUserBillsByDateRange(DateTime startDate, DateTime endDate) async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  var queryResult = await db.query('UserBill',
      columns: ["dateTime"],
      where: 'dateTime >= ? AND dateTime <= ? GROUP BY dateTime',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);
  List listmap = [];
  var totalmouthPrice = await db.query('UserBill',
      columns: ['SUM(price) as totalMouthPrice'],
      where: 'dateTime >= ? AND dateTime <=  ? ',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);
  print("totalmouthPrice");
  print(totalmouthPrice[0]["totalMouthPrice"]);
  var paymouthPrice = await db.query('UserBill',
      columns: ['SUM(price) as paymouthPrice'],
      where: 'dateTime >= ? AND dateTime <=  ? AND price< 0 ',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);
  var incomemouthPrice = await db.query('UserBill',
      columns: ['SUM(price) as incomemouthPrice'],
      where: 'dateTime >= ? AND dateTime <=  ? AND price>0 ',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);
  double zero = 0;
  for (var item in queryResult) {
    var queydata = await db.query('UserBill', where: 'dateTime = ? ', whereArgs: [item["dateTime"]]);
    var totalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalDayPrice'], where: 'dateTime = ? ', whereArgs: [item["dateTime"]]);
    // listmap[item["dateTime"]] = {"data": queydata, "totalMouthPrice": totalMouthPrice[0]["totalMouthPrice"]};
    listmap.add({
      "totalDayPrice": totalDayPrice[0]["totalDayPrice"],
      "time": item["dateTime"],
      "totalmouthPrice": totalmouthPrice[0]["totalMouthPrice"] == null ? zero : totalmouthPrice[0]["totalMouthPrice"],
      "paymouthPrice": paymouthPrice[0]["paymouthPrice"] == null ? zero : paymouthPrice[0]["paymouthPrice"],
      "incomemouthPrice":
          incomemouthPrice[0]["incomemouthPrice"] == null ? zero : incomemouthPrice[0]["incomemouthPrice"],
      "data": queydata.toList(),
    });
  }

  return listmap;
}

Future<List> getall() async {
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  var queryResult = await db.query("UserBill");

  return queryResult;
}

Future<List> getWeekData() async {
  var datalist = [];
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  // 获取当前日期
  int nowyear = DateTime.now().year; //今年
  int nowmonth = DateTime.now().month; //这个月是几月
  print("month=" + nowmonth.toString());
  int nowday = DateTime.now().day; //今天
  int weekday = DateTime.now().weekday; //今天是本周的第几天
  String weekstart = new DateTime(nowyear, nowmonth, nowday - weekday + 1).toString();
  print(weekstart);
  DateTime now = DateTime.parse(weekstart);
  // 生成连续7天的日期
  List<DateTime> dates = [DateTime.parse(now.toString().substring(0, 10))];
  for (int i = 1; i < 7; i++) {
    now = now.add(Duration(days: 1));
    var date = now.toString().substring(0, 10);
    dates.add(DateTime.parse(date));
  }

  for (int i = 0; i < 7; i++) {
    var totalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalDayPrice'],
        where: 'dateTime = ? and  price < 0',
        whereArgs: [dates[i].toIso8601String()]);
    if (totalDayPrice[0]["totalDayPrice"] == null) {
      double zero = 0;
      datalist.add(zero);
    } else {
      datalist.add(totalDayPrice[0]["totalDayPrice"]);
    }
  }
  return datalist;
}

Future<List> getmouthtotal(DateTime date) async {
  var datalist = [];
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  DateTime monthStart = DateTime(date.year, date.month, 1);
  DateTime monthEnd = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  var mouthendday = monthEnd.day;
  List<DateTime> dates = [];
  dates.add(DateTime.parse(monthStart.toString().substring(0, 10)));
  for (int i = 1; i < mouthendday; i++) {
    monthStart = monthStart.add(Duration(days: 1));
    var date = monthStart.toString().substring(0, 10);
    dates.add(DateTime.parse(date));
  }
  for (int i = 0; i < mouthendday; i++) {
    var totalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalDayPrice'], where: 'dateTime = ? ', whereArgs: [dates[i].toIso8601String()]);
    var paytotalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as paytotalDayPrice'],
        where: 'dateTime = ? and price < 0',
        whereArgs: [dates[i].toIso8601String()]);
    var incometotalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as paytotalDayPrice'],
        where: 'dateTime = ? and price > 0',
        whereArgs: [dates[i].toIso8601String()]);
    double zero = 0;
    if (totalDayPrice[0]["totalDayPrice"] == null) {
      var json = {
        "index": i,
        "totalDayPrice": zero,
        "date": dates[i],
        "paytotalDayPrice": zero,
        "incometotalDayPrice": zero
      };
      datalist.add(json);
    } else {
      datalist.add({
        "index": i,
        "totalDayPrice": totalDayPrice[0]["totalDayPrice"],
        "date": dates[i],
        "paytotalDayPrice":
            paytotalDayPrice[0]["paytotalDayPrice"] == null ? zero : paytotalDayPrice[0]["paytotalDayPrice"],
        "incometotalDayPrice":
            incometotalDayPrice[0]["paytotalDayPrice"] == null ? zero : incometotalDayPrice[0]["paytotalDayPrice"]
      });
    }
  }

  return datalist;
}

Future<List> gettotalmouthBytype(DateTime date, int type) async {
  var typelist = [];
  if (type == 0) {
    typelist = paylist;
  } else {
    typelist = incomelist;
  }
  var datalist = [];
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  DateTime monthStart = DateTime(date.year, date.month, 1);
  DateTime monthEnd = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

  for (int i = 0; i < typelist.length; i++) {
    var queryResult = await db.query('UserBill',
        columns: ["dateTime", "price", "title", "type", "othertext"],
        where: 'dateTime >= ? AND dateTime <= ? AND title=? ORDER BY dateTime',
        whereArgs: [monthStart.toIso8601String(), monthEnd.toIso8601String(), typelist[i]]);
    var totalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalDayPrice'],
        where: 'dateTime >= ? AND dateTime <= ? AND title=? ORDER BY dateTime',
        whereArgs: [monthStart.toIso8601String(), monthEnd.toIso8601String(), typelist[i]]);
    var totalmouthPrice;
    if (type == 0) {
      totalmouthPrice = await db.query('UserBill',
          columns: ['SUM(price) as totalmouthPrice'],
          where: 'dateTime >= ? AND dateTime <= ?AND price<0  ORDER BY dateTime',
          whereArgs: [monthStart.toIso8601String(), monthEnd.toIso8601String()]);
    } else {
      totalmouthPrice = await db.query('UserBill',
          columns: ['SUM(price) as totalmouthPrice'],
          where: 'dateTime >= ? AND dateTime <= ?AND price>0  ORDER BY dateTime',
          whereArgs: [monthStart.toIso8601String(), monthEnd.toIso8601String()]);
    }
    double zero = 0;
    if (queryResult.length != 0) {
      datalist.add({
        "totalmouthPrice": totalmouthPrice[0]["totalmouthPrice"],
        "title": typelist[i],
        "totalDayPrice": totalDayPrice[0]["totalDayPrice"],
        "data": queryResult,
      });
    }
  }
  print(datalist);
  return datalist;
}

Future<List> gettotalyeartBytype(DateTime date, int type) async {
  var typelist = [];
  if (type == 0) {
    typelist = paylist;
  } else {
    typelist = incomelist;
  }
  var datalist = [];
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  DateTime yearStart = DateTime(date.year, 1, 1);
  DateTime yearEnd = DateTime(date.year + 1, 1, 0, 23, 59, 59);
  for (int i = 0; i < typelist.length; i++) {
    var queryResult = await db.query('UserBill',
        columns: ["dateTime", "price", "title", "type", "othertext"],
        where: 'dateTime >= ? AND dateTime <= ? AND title=? ORDER BY dateTime',
        whereArgs: [yearStart.toIso8601String(), yearEnd.toIso8601String(), typelist[i]]);
    var totalDayPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalDayPrice'],
        where: 'dateTime >= ? AND dateTime <= ? AND title=? ORDER BY dateTime',
        whereArgs: [yearStart.toIso8601String(), yearEnd.toIso8601String(), typelist[i]]);
    var totalmouthPrice;
    if (type == 0) {
      totalmouthPrice = await db.query('UserBill',
          columns: ['SUM(price) as totalmouthPrice'],
          where: 'dateTime >= ? AND dateTime <= ?AND price<0  ORDER BY dateTime',
          whereArgs: [yearStart.toIso8601String(), yearEnd.toIso8601String()]);
    } else {
      totalmouthPrice = await db.query('UserBill',
          columns: ['SUM(price) as totalmouthPrice'],
          where: 'dateTime >= ? AND dateTime <= ?AND price>0  ORDER BY dateTime',
          whereArgs: [yearStart.toIso8601String(), yearEnd.toIso8601String()]);
    }
    double zero = 0;
    if (queryResult.length != 0) {
      datalist.add({
        "totalmouthPrice": totalmouthPrice[0]["totalmouthPrice"],
        "title": typelist[i],
        "totalDayPrice": totalDayPrice[0]["totalDayPrice"],
        "data": queryResult,
      });
    }
  }
  print(datalist);
  return datalist;
}

Future<List> getyeartotal(DateTime date) async {
  var datalist = [];
  final dir = await getDatabasesPath();
  final path = join(dir, 'my_database.db');
  Database db = await openDatabase(path);
  DateTime monthStart = DateTime(date.year, 1, 1);
  DateTime monthEnd = DateTime(date.year, 2, 0, 23, 59, 59);
  var mouthendday = monthEnd.day;
  List dates = [];
  dates.add({
    "monthStart": monthStart,
    "monthEnd": monthEnd,
  });
  for (int i = 1; i < 12; i++) {
    monthStart = DateTime(monthStart.year, 1 + i, 1);
    monthEnd = DateTime(monthEnd.year, 2 + i, 0, 23, 59, 59);

    dates.add({
      "monthStart": monthStart,
      "monthEnd": monthEnd,
    });
  }
  for (int i = 0; i < 12; i++) {
    var totalmouthPrice = await db.query('UserBill',
        columns: ['SUM(price) as totalMouthPrice'],
        where: 'dateTime >= ? AND dateTime <=  ? ',
        whereArgs: [dates[i]["monthStart"].toIso8601String(), dates[i]["monthEnd"].toIso8601String()]);
    var paymouthPrice = await db.query('UserBill',
        columns: ['SUM(price) as paymouthPrice'],
        where: 'dateTime >= ? AND dateTime <=  ? AND price< 0 ',
        whereArgs: [dates[i]["monthStart"].toIso8601String(), dates[i]["monthEnd"].toIso8601String()]);
    var incomemouthPrice = await db.query('UserBill',
        columns: ['SUM(price) as incomemouthPrice'],
        where: 'dateTime >= ? AND dateTime <=  ? AND price>0 ',
        whereArgs: [dates[i]["monthStart"].toIso8601String(), dates[i]["monthEnd"].toIso8601String()]);
    double zero = 0;
    if (totalmouthPrice[0]["totalMouthPrice"] == null) {
      var json = {
        "index": i,
        "totalDayPrice": zero,
        "date": dates[i]["monthStart"],
        "paymouthPrice": zero,
        "incomemouthPrice": zero
      };
      datalist.add(json);
    } else {
      datalist.add({
        "index": i,
        "totalDayPrice": totalmouthPrice[0]["totalMouthPrice"],
        "date": dates[i]["monthStart"],
        "paymouthPrice": paymouthPrice[0]["paymouthPrice"] == null ? zero : paymouthPrice[0]["paymouthPrice"],
        "incomemouthPrice":
            incomemouthPrice[0]["incomemouthPrice"] == null ? zero : incomemouthPrice[0]["incomemouthPrice"]
      });
    }
  }
  print(datalist);
  return datalist;
}
