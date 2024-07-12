
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';


import 'Color.dart';

class Calculator extends StatefulWidget {
  final tabindex;
  final Function saveData;
  const Calculator({super.key, required this.saveData, this.tabindex});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // 初始化
  @override
  void initState() {
    notesfoucos.addListener(() {
      if (notesfoucos.hasFocus) {
        setState(() {
          margin = 55;
          showbtn = false;
        });
      } else {
        setState(() {
          margin = 0;
          showbtn = true;
        });
      }
    });

    super.initState();
  }

  double margin = 0;
// 金额
  var preprice = "0";
  var price = 0;
  var symbol = "";
// 是否隐藏键盘
  var showbtn = true;
// 输入框焦点
  FocusNode notesfoucos = FocusNode();
  // 选择日期回调
  changgeDate() {
    BrnDatePicker.showDatePicker(context,
        initialDateTime: DateTime.parse(date),
        // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
        // pickerMode: BrnDateTimePickerMode.date,
        // minuteDivider: 30,
        pickerTitleConfig: BrnPickerTitleConfig.Default,
        dateFormat: 'yyyy年,MMMM月,dd日', onConfirm: (dateTime, list) {
      print(dateTime);
      setState(() {
        date = dateTime.toString().substring(0, 10);
      });
    }, onClose: () {
      print("onClose");
    }, onCancel: () {
      print("onCancel");
    }, onChange: (dateTime, list) {});
  }

  // 日期
  String date = DateTime.now().toString().substring(0, 10);
  final TextEditingController notesController = TextEditingController();
  // 点击按钮
  btnclick(text) {
    print(text);
    if (preprice == "0") {
      if (text == "删除") {
        return;
      }
      preprice = text;
    } else {
      if (text == "删除") {
        if (preprice.length > 1) {
          preprice = preprice.substring(0, preprice.length - 1);
        } else {
          preprice = "0";
        }
      } else if (text == '.') {
        if (preprice.contains(".")) {
          return;
        }
        symbol = ".";
      } else {
        if (preprice.contains(".")) {
          if (preprice.substring(preprice.indexOf("."), preprice.length).length > 2) {
            BrnToast.show("最多两位小数", context);
            return;
          }
        }
        if (symbol == ".") {
          preprice = preprice + symbol + text;
          symbol = "";
        } else {
          preprice = preprice + text;
        }
      }
    }

    setState(() {});
  }

// 保存
  // save() {

  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: margin),
        color: baColor,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      focusNode: notesfoucos,
                      textAlign: TextAlign.left,
                      controller: notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "备注",
                        fillColor: Color.fromRGBO(245, 245, 245, 0.9), // 设置输入框背景色为灰色
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          preprice,
                          style:
                              TextStyle(color: widget.tabindex == 0 ? Colors.red.shade400 : Colors.green, fontSize: 18),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              height: 50,
              // color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(date),
                      onTap: () => changgeDate(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Visibility(
              visible: showbtn,
              child: Container(
                // color: Colors.black,
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("1"),
                                  child: Text("1"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("2"),
                                  child: Text("2"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("3"),
                                  child: Text("3"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("删除"),
                                  child: Text("删除"),
                                ))),
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("4"),
                                  child: Text("4"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("5"),
                                  child: Text("5"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("6"),
                                  child: Text("6"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("."),
                                  child: Text("."),
                                ))),
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("7"),
                                  child: Text("7"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("8"),
                                  child: Text("8"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("9"),
                                  child: Text("9"),
                                ))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                                      elevation: MaterialStatePropertyAll(0)),
                                  onPressed: () => btnclick("0"),
                                  child: Text("0"),
                                ))),
                      ],
                    )),
                    Expanded(
                        child: Container(
                            width: 500,
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  // foregroundColor: MaterialStatePropertyAll(Colors.black),
                                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                                  elevation: MaterialStatePropertyAll(0)),
                              onPressed: () {
                                if (preprice == "0") {
                                  return BrnToast.show("请输入金额", context);
                                }
                                widget.saveData({"date": date, "price": preprice, "othertext": notesController.text});
                              },
                              child: Text(
                                "保存",
                                style: TextStyle(color: Colors.red.shade400),
                              ),
                            )))
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class Caculatorbutton extends StatefulWidget {
  var text;

  Caculatorbutton({Key? key, this.text}) : super(key: key);

  @override
  State<Caculatorbutton> createState() => CaculatorState();
}

class CaculatorState extends State<Caculatorbutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      alignment: Alignment.center,
      child: Text(widget.text),
    );
  }
}
