import 'package:flutter/material.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/Pref.dart';
import 'package:stock_helper/util/common_util.dart';
import 'package:stock_helper/util/log_util.dart';

enum StockWebSite { Sina, XueQiu, TongHuaShun }

class StockWebSiteUtil {
  static String getText(BuildContext context, StockWebSite stockWebSite) {
    switch (stockWebSite) {
      case StockWebSite.Sina:
        return I18n.of(context).text('sina');
      case StockWebSite.XueQiu:
        return I18n.of(context).text('xueqiu');
      case StockWebSite.TongHuaShun:
        return I18n.of(context).text('tonghuashun');
    }
    return "";
  }

  static Future<void> showStockInfo(String code) async {
    int i = await Pref.getInt(
        PrefKey.settingStockWebSite, PrefDefault.stockWebsiteIndex);
    String url = 'https://xueqiu.com/S/$code';
    switch (StockWebSite.values[i]) {
      case StockWebSite.Sina:
        url = 'https://finance.sina.com.cn/realstock/company/$code/nc.shtml';
        break;
      case StockWebSite.XueQiu:
        code =
            code.startsWith('hk') ? code.replaceAll(RegExp(r'hk'), '') : code;
        url = 'https://xueqiu.com/S/$code';
        break;
      case StockWebSite.TongHuaShun:
        code = code.startsWith('hk')
            ? code.toUpperCase()
            : code.replaceAll(RegExp(r'sh|sz'), '');
        url = 'http://stockpage.10jqka.com.cn/$code/';
        break;
    }
    logUtil.d('launchURL $url');
    CommonUtil.launchURL(url);
  }
}
