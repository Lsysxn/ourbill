import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';


GlobalKey<_incomeState> incomeKey = GlobalKey();

class income extends StatefulWidget {
  const income({super.key});

  @override
  State<income> createState() => _incomeState();
}

class _incomeState extends State<income> {
  var title = "工资";
  var listmap = [];
  var showIconColorindex = 0;
  @override
  void initState() {
    super.initState();
    var one = {
      "attive": true,
      "icon": "resources/image/account/add/wages.png",
      "isons": "resources/image/account/add/wagess.png",
      "text": "工资"
    };
    var two = {
      "attive": false,
      "icon": "resources/image/account/add/bag.png",
      "isons": "resources/image/account/add/bags.png",
      "text": "红包"
    };

    listmap.add(one);
    listmap.add(two);
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
                      style: TextStyle(color: item["attive"] == false ? Colors.grey : Colors.green, fontSize: 12),
                      onTap: () => choose(item),
                      name: item["text"],
                      iconWidget: item["attive"] == false
                          ? Image.asset(item["icon"])
                          : Image.asset(
                        item["isons"],
                        color: Colors.green,
                      ),
                    );
                  }).toList(),
                )),
            // Expanded(flex: 2, child: Calculator())
          ],
        ));
  }
}
