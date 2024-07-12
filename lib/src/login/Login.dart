import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // _userCountController.text = "123456";
    // _userPassworldController.text = "123456";
    // TODO: implement initState
    super.initState();
  }

  void login() {
    Get.toNamed('/TabHome');
  }

  final TextEditingController _userCountController = TextEditingController();
  final TextEditingController _userPassworldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      appBar: BrnAppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "登录",
                style: TextStyle(color: Colors.black),
              ),
            ],
          )),
      drawer: Drawer(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Color.fromRGBO(245, 245, 245, 0.9),

            ///SizedBox 用来限制一个固定 width height 的空间
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                  color: Colors.white24,
                  margin: EdgeInsets.only(top: 60),
                  padding: EdgeInsets.all(40),

                  ///距离顶部
                  // margin: EdgeInsets.only(top: 30),
                  // padding: EdgeInsets.all(10),

                  ///Alignment 用来对齐 Widget
                  // alignment: Alignment(0, 0),

                  ///文本输入框
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 80),
                            child: const Text(
                              "记账app",
                              style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                            )),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: _userCountController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: "账号",
                              fillColor: Colors.white, // 设置输入框背景色为灰色
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _userPassworldController,
                          decoration: const InputDecoration(
                              hintText: "输入密码",
                              fillColor: Colors.white, // 设置输入框背景色为灰色
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              shape: const StadiumBorder(), //圆角
                            ),
                            icon: Icon(Icons.login),
                            label: Text("登录")),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: InkWell(
                                child: Text(
                                  "创建新帐号",
                                  style: TextStyle(color: Color.fromRGBO(78, 161, 247, 1)),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 30),
                              child: InkWell(
                                child: Text(
                                  "忘记密码？",
                                  style: TextStyle(color: Color.fromRGBO(78, 161, 247, 1)),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ),
          // 底部注册模块
          Positioned(
              bottom: 55,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("---第三方登录---", style: TextStyle(color: Colors.grey)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'resources/image/login/wechat.png',
                          width: 45,
                          height: 45,
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
