import 'package:flutter/material.dart';

class property extends StatefulWidget {
  const property({super.key});

  @override
  State<property> createState() => _propertyState();
}

class _propertyState extends State<property> {
  @override
  void dispose() {
    print("嘻嘻嘻");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
