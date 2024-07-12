import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import './src/router/router.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import "./src/login/Login.dart";
void main() {
  runApp(GetMaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      BrnLocalizationDelegate.delegate,
    ],
    supportedLocales: [
      // Locale('en', 'US'),
      Locale('zh', 'CN'),
      // Locale('de', 'DE'),
    ],
    home: Login(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    // onGenerateRoute: onGenerateRoute,
    getPages: page,
  ));
}
