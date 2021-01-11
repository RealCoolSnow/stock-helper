import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';

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
}
