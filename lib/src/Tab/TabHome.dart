


import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../commponts/draw.dart';
import './Bill.dart';
import './property.dart';

class Tabhome extends StatefulWidget {
  const Tabhome({super.key});

  @override
  State<Tabhome> createState() => _TabhomeState();
}

class _TabhomeState extends State<Tabhome> {
  final Storage = GetStorage();
  // 图标索引
  var currentIndex = 0;
  // 显示body索引
  var bodyindex = 0;
  // 文字
  var titles = ["账单", "", "资产"];
  var page = [
    Bill(
      key: BillKey,
    ),
    property()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BrnBottomTabBar(
        currentIndex: currentIndex,
        onTap: (Value) async {
          print(Value);
          var proindex = currentIndex;
          setState(() {
            currentIndex = Value;
            bodyindex = Value;
            if (Value == 2) {
              bodyindex = 1;
            }
          });
          if (Value == 1) {
            var data = await Get.toNamed("/addAccount");
            print(data);
            if (data) {
              print("zegjie");
              BillKey.currentState?.getdata(DateTime.parse(Storage.read("mouthDate") + "-01"));
              BillKey.currentState?.getweekdata();
            }
            setState(() {
              currentIndex = proindex;
              bodyindex = proindex;
              if (proindex == 2) {
                bodyindex = 1;
              }
            });
          }
        },
        isAnimation: true,
        fixedColor: Colors.blue,
        items: [
          BrnBottomTabBarItem(
              icon: Image.asset(
                'resources/image/hometable/home.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'resources/image/hometable/activehome.png',
                width: 20,
                height: 20,
              ),
              title: Text(titles[0])),
          BrnBottomTabBarItem(
              icon: Image.asset(
                'resources/image/hometable/add.png',
                width: 25,
                height: 25,
              ),
              title: Text(titles[1])),
          BrnBottomTabBarItem(
              icon: Image.asset(
                'resources/image/hometable/property.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'resources/image/hometable/activeproperty.png',
                width: 20,
                height: 20,
              ),
              title: Text(titles[0])),
        ],
      ),
      body: Container(
        // child: page[bodyindex],
        child: IndexedStack(
          index: bodyindex,
          children: page,
        ),
      ),
    );
  }
}
