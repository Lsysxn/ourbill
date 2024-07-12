
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';


import '../commponts/Color.dart';

GlobalKey<_expenditureState> expenditureKey = GlobalKey();

class expenditure extends StatefulWidget {
  const expenditure({super.key});

  @override
  State<expenditure> createState() => _expenditureState();
}

class _expenditureState extends State<expenditure> {
  var title = "三餐";
  var listmap = [];
  var showIconColorindex = 0;
  @override
  void initState() {
    super.initState();
    var one = {
      "attive": true,
      "icon": "resources/image/account/add/dinner.png",
      "isons": "resources/image/account/add/dinners.png",
      "text": "三餐"
    };
    var two = {
      "attive": false,
      "icon": "resources/image/account/add/cloth.png",
      "isons": "resources/image/account/add/cloths.png",
      "text": "衣服"
    };
    var three = {
      "attive": false,
      "icon": "resources/image/account/add/fruit.png",
      "isons": "resources/image/account/add/fruits.png",
      "text": "水果"
    };
    var four = {
      "attive": false,
      "icon": "resources/image/account/add/love.png",
      "isons": "resources/image/account/add/loves.png",
      "text": "恋爱"
    };
    var five = {
      "attive": false,
      "icon": "resources/image/account/add/sug.png",
      "isons": "resources/image/account/add/sugs.png",
      "text": "零食"
    };
    var six = {
      "attive": false,
      "icon": "resources/image/account/add/trafic.png",
      "isons": "resources/image/account/add/trafics.png",
      "text": "交通"
    };
    var seven = {
      "attive": false,
      "icon": "resources/image/account/add/trafic.png",
      "isons": "resources/image/account/add/trafics.png",
      "text": "娱乐"
    };
    listmap.add(one);
    listmap.add(two);
    listmap.add(three);
    listmap.add(four);
    listmap.add(five);
    listmap.add(six);
    listmap.add(seven);
  }

  choose(item) {
    print(item);
    listmap.forEach((element) {
      element["attive"] = false;
    });
    item["attive"] = true;
    title = item["text"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: GridView.count(
                  crossAxisCount: 5,
                  childAspectRatio: 1.0,
                  children: listmap.map((item) {
                    return BrnIconButton(
                      direction: Direction.bottom,
                      style: TextStyle(color: item["attive"] == false ? Colors.grey : ThemeColor, fontSize: 12),
                      onTap: () => choose(item),
                      name: item["text"],
                      iconWidget: item["attive"] == false ? Image.asset(item["icon"]) : Image.asset(item["isons"]),
                    );
                  }).toList(),
                )),
            // Expanded(flex: 2, child: Calculator())
          ],
        ));
  }
}
