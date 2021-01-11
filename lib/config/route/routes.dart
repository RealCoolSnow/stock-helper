/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 10:47:39
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-17 19:05:01
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:stock_helper/config/route/route_handlers.dart';

/// Usage:
///
/// router.navigateTo(context, Routes.home, transition: TransitionType.fadeIn);
///
///
class Routes {
  static const String home = "/";
  static const String setting = "/setting";
  static const String stock_list = "/stock_list";
  static const String about = "/about";
  static const String stock_website_setting = "/stock_website_setting";
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    // router.define(home, handler: homeHandler);
    router.define(setting, handler: settingHandler);
    router.define(stock_list, handler: stockListHandler);
    router.define(about,
        handler: aboutHandler, transitionType: TransitionType.fadeIn);
    router.define(stock_website_setting, handler: stockWebSiteSettingHandler);
  }
}
