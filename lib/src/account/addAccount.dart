import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import '../commponts/Calculator.dart';
import '../commponts/UserBill.dart';
import 'expenditure.dart';
import 'income.dart';



class addAccount extends StatefulWidget {
  const addAccount({super.key});

  @override
  State<addAccount> createState() => _addAccountState();
}

class _addAccountState extends State<addAccount> with TickerProviderStateMixin {
  final Storage = GetStorage();
  @override
  void initState() {
    initDataBase();
    // getdata();
    super.initState();
  }

  var tabindex = 0;
  getdata() async {
    // 获取当前日期时间
    DateTime now = DateTime.now();
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    print(monthStart);
    print(monthEnd);
    Future<List> list = getUserBillsByDateRange(monthStart, monthEnd);
    var mouthdata = await list;
    print(mouthdata);
  }

  save(data) {
    var title;
    var price;
    if (tabindex == 0) {
      title = expenditureKey.currentState?.title;
      price = -double.parse(data["price"]);
    } else {
      title = incomeKey.currentState?.title;
      price = double.parse(data["price"]);
    }
    var dateTime = DateTime.parse(data["date"]);
    ;
    UserBill userBill = UserBill("", price, title!, data["othertext"], DateTime.parse(data["date"]));
    print(userBill.dateTime);
    addUserBill(userBill);
    print(expenditureKey.currentState?.title);
    // closeDatabase();
    // print(Storage.read("mouthDate"));
    // print(data["date"].substring(0, 7));
    // return;
    if (Storage.read("mouthDate") == data["date"].substring(0, 7)) {
      print(111);
      Get.back(result: true);
    } else {
      print(222);
      print(Storage.read("mouthDate"));
      Get.back(result: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 返回
    close() {
      closeDatabase();
      Get.back(result: false);
    }

    var TabContr = TabController(length: 2, vsync: this);
// pageview控制器
    PageController pagecontro = PageController(initialPage: 0);
    void initState() {
      // billdata[1] = "Bush";
      print(pagecontro.initialPage);
      // TODO: implement initState
      super.initState();
    }

// 改变tabar
    changgeTabar(state, index) {
      pagecontro.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      print(index);

      setState(() {
        tabindex = index;
      });
    }

    return Scaffold(
      appBar: BrnAppBar(
        showDefaultBottom: true,
        leading: Container(
            padding: EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: close,
              child: Image.asset("resources/image/account/close.png"),
            )),
        actions: Container(
          height: 100,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 110),
                child: BrnTabBar(
                  indicatorColor: tabindex == 0 ? Colors.blue.shade300 : Colors.green,
                  labelColor: tabindex == 0 ? Colors.blue.shade300 : Colors.green,
                  onTap: (state, index) => changgeTabar(state, index),
                  tabWidth: 70,
                  tabs: [BadgeTab(text: "支出"), BadgeTab(text: "收入")],
                  controller: TabContr,
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView(
                onPageChanged: (value) {
                  TabContr.animateTo(value);
                  print(value);
                },
                controller: pagecontro,
                children: [
                  Container(
                    // color: Colors.amber,
                    child: expenditure(
                      key: expenditureKey,
                    ),
                  ),
                  Container(
                    child: income(
                      key: incomeKey,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Calculator(
                  tabindex: tabindex,
                  saveData: (data) => save(data),
                ))
          ],
        ),
      ),
    );
  }
}
