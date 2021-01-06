import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_item.dart';
import 'package:stock_helper/http/http_util.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/log_util.dart';

///
class StockUtil {
  static List<StockItem> stockList;
  //
  static void loadAllStocks(BuildContext context) {
    HttpUtil().get('/list', getParams: {}).then((data) {
      stockList = data
          .map((item) => StockItem.fromJson(item))
          .toList()
          .cast<StockItem>();
      logUtil.d("loadAllStocks: total = ${stockList.length}");
    }).catchError((error) {
      logUtil.d(error.message);
      DialogUtil.showMessage(context, 'error', error.message);
    });
  }
}
