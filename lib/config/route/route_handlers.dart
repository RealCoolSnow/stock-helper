/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 10:44:05
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 18:50:07
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:stock_helper/ui/pages/about.dart';
import 'package:stock_helper/ui/pages/setting.dart';
import 'package:stock_helper/ui/pages/stock_list.dart';

/// home
// var homeHandler = Handler(
//     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//   return HomePage();
// });

var stockListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StockListPage();
});

var settingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SettingPage();
});

/// about
var aboutHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AboutPage();
});
