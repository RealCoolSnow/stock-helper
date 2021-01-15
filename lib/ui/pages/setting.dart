import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/util/stock_website.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/Pref.dart';
import 'package:stock_helper/ui/app_theme.dart';
import 'package:stock_helper/util/tray_util.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _settingTrayIcon = PrefDefault.settingTrayIcon;
  String _stockWebSite = '';
  _SettingPageState() {
    Pref.getBool(PrefKey.settingTrayIcon, PrefDefault.settingTrayIcon)
        .then((value) {
      _settingTrayIcon = value;
    });
    _updateStockWebSite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context).text("setting"))),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile.switchTile(
                title: I18n.of(context).text('show_tray'),
                subtitle: I18n.of(context).text('show_tray_tip'),
                leading: Icon(Icons.notifications),
                switchValue: _settingTrayIcon,
                switchActiveColor: AppTheme.secondary,
                onToggle: (bool value) {
                  Pref.setBool(PrefKey.settingTrayIcon, value).then((result) {
                    if (result) {
                      setState(() {
                        _settingTrayIcon = value;
                      });
                      TrayUtil.refreshState(I18n.of(context).text('app_name'));
                    }
                  });
                },
              ),
              SettingsTile(
                title: I18n.of(context).text('stock_website'),
                subtitle: _stockWebSite,
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  Config.router
                      .navigateTo(context, Routes.stock_website_setting,
                          transition: TransitionType.fadeIn)
                      .then((value) {
                    _updateStockWebSite();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _updateStockWebSite() {
    Pref.getInt(PrefKey.settingStockWebSite, PrefDefault.stockWebsiteIndex)
        .then((value) {
      setState(() {
        _stockWebSite =
            StockWebSiteUtil.getText(context, StockWebSite.values[value]);
      });
    });
  }
}
