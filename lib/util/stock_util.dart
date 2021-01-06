import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_item.dart';
import 'package:stock_helper/http/http_util.dart';
import 'package:stock_helper/storage/sqflite/sql_table_data.dart';
import 'package:stock_helper/storage/sqflite/sql_util.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/log_util.dart';

///
class StockUtil {
  static List<StockItem> stockList = [];
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

  static List<StockItem> searchStocks(String text, {int maxCount}) {
    List<StockItem> list = [];
    if (text != null) {
      text = text.trim();
      if (text.isNotEmpty) {
        for (var item in stockList) {
          if (item.name.contains(text) || item.code.contains(text)) {
            list.add(item);
          }
          if (list.length >= maxCount) {
            break;
          }
        }
      }
    }
    logUtil.d("searchStocks '$text': count = ${list.length}");
    return list;
  }

  static Future<bool> addStock(StockItem stockItem) async {
    var sql = SqlUtil.setTable(SqlTable.NAME_STOCKS);
    var conditions = {'code': stockItem.code};
    var result = await sql.query(conditions: conditions);
    logUtil.d('addStock - query $result');
    if (result == null || result.isEmpty) {
      var item = {'code': stockItem.code, 'name': stockItem.name};
      var id = await sql.insert(item);
      logUtil.d('addStock - insert $id');
      return id > 0;
    }
    return false;
  }
}
