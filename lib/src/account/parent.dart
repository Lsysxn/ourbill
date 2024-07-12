import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chidren.dart';

class parent extends StatefulWidget {
  const parent({super.key});

  @override
  State<parent> createState() => _parentState();
}

class _parentState extends State<parent> {
  var value = 0; //给子组件传值
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          childrenKey.currentState?.chindmrthods(); //通过childrenKey调用子组件的方法或者属性
        },
        child: children(value: value), //自组件接受父组件的值
      ),
    );
  }
}
