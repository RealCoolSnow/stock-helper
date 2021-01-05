import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text(I18n.of(context).text("setting"))),
      body: Center(
        child: RaisedButton(
          child: Text(I18n.of(context).text('about')),
          onPressed: () {
            Config.router.navigateTo(context, Routes.about,
                transition: TransitionType.fadeIn);
          },
        ),
      ),
    );
  }
}