import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Tab/Bill.dart';
import '../Tab/TabHome.dart';
import '../account/addAccount.dart';
import '../Summary/totalYearOrMouth.dart';
import '../calendarPage/calendarPage.dart';

var page = [
  GetPage(name: '/TabHome', page: () => const Tabhome()),
  GetPage(name: '/addAccount', page: () => const addAccount()),
  GetPage(name: '/totalYearOrMouth', page: () => const totalYearOrMouth()),
  GetPage(name: '/calendarPage', page: () => const alendarpage()),
];
