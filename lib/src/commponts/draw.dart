import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: [
              InkWell(
                child: Container(
                  height: 200,
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        // color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                    //设置用户名
                    accountName: new Text(
                      '瑶总',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    //设置用户邮箱
                    accountEmail: new Text(
                      '赚五百万',
                      style: TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
                    ),
                    //设置当前用户的头像
                    currentAccountPicture: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://img0.baidu.com/it/u=2281576848,3465781103&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1679072400&t=021a09ef3daf502b07e0d212ceb8b9f2"),
                    ),
                    //回调事件
                    // onDetailsPressed: () {},
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                onTap: () {},
                title: Text("搜索账单"),
                leading: Icon(Icons.search),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {},
                title: Text("设置"),
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.chevron_right),
              )
            ],
          ),
        ],
      ),
    );
  }
}
