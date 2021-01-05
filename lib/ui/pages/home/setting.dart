import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text(I18n.of(context).text('about')),
        onPressed: () {
          Config.router.navigateTo(context, Routes.about,
              transition: TransitionType.fadeIn);
        },
      ),
    );
  }
}
