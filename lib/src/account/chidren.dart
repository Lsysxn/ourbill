import 'package:flutter/cupertino.dart';

GlobalKey<_childrenState> childrenKey = GlobalKey();

class children extends StatefulWidget {
  final value;
  const children({super.key, this.value}); //接受父组件传的值

  @override
  State<children> createState() => _childrenState();
}

class _childrenState extends State<children> {
  chindmrthods() {
    print("我被调用了");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.value),
    );
  }
}
