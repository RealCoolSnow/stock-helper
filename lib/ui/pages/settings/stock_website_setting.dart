import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/util/stock_website.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/Pref.dart';
import 'package:stock_helper/ui/app_theme.dart';

class StockWebSiteSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StockWebSiteSettingPageState();
}

class _StockWebSiteSettingPageState extends State<StockWebSiteSettingPage> {
  int current = 0;
  _StockWebSiteSettingPageState() {
    Pref.getInt(PrefKey.settingStockWebSite).then((value) {
      setState(() {
        current = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context).text('stock_website'))),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: StockWebSiteUtil.getText(context, StockWebSite.Sina),
              trailing: trailingWidget(StockWebSite.Sina.index),
              onPressed: (context) => changeWebSite(StockWebSite.Sina.index),
            ),
            SettingsTile(
              title: StockWebSiteUtil.getText(context, StockWebSite.XueQiu),
              trailing: trailingWidget(StockWebSite.XueQiu.index),
              onPressed: (context) => changeWebSite(StockWebSite.XueQiu.index),
            ),
            SettingsTile(
              title:
                  StockWebSiteUtil.getText(context, StockWebSite.TongHuaShun),
              trailing: trailingWidget(StockWebSite.TongHuaShun.index),
              onPressed: (context) =>
                  changeWebSite(StockWebSite.TongHuaShun.index),
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (current == index)
        ? Icon(Icons.check, color: AppTheme.secondary)
        : Icon(null);
  }

  void changeWebSite(int index) {
    setState(() {
      current = index;
    });
    Pref.setInt(PrefKey.settingStockWebSite, index);
  }
}
