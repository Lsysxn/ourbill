import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomDatePicker extends StatefulWidget {
  // final DateTime initialDate;
  // final DateTime firstDate;
  // final DateTime lastDate;
  // final Function onChanged;
  // final String format;
  final String text;

  CustomDatePicker({
    // required this.initialDate,
    // required this.firstDate,
    // required this.lastDate,
    // required this.onChanged,
    // required this.format,
    required this.text,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.text), // 在日期下面显示文字
        InkWell(
          child: Text('Open Date Picker'),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 250,
                  width: 300,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        selectedDate = newDateTime;
                      });
                      ; // 调用回调函数，传递选择的日期
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
