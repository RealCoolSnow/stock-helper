import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/bean/stock_price.dart';
import 'package:stock_helper/http/http_util.dart';
import 'package:stock_helper/storage/sqflite/sql_table_data.dart';
import 'package:stock_helper/storage/sqflite/sql_util.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/log_util.dart';

///
class StockUtil {
  static const String API_STOCK = 'https://hq.sinajs.cn/list=';
  static List<StockBasicInfo> stockList = [];
  //
  static void loadAllStocks(BuildContext context) {
    HttpUtil().get('/list', getParams: {}).then((data) {
      stockList = data
          .map((item) => StockBasicInfo.fromJson(item))
          .toList()
          .cast<StockBasicInfo>();
      logUtil.d("loadAllStocks: total = ${stockList.length}");
    }).catchError((error) {
      logUtil.d(error.message);
      DialogUtil.showMessage(context, 'error', error.message);
    });
  }

  static List<StockBasicInfo> searchStocks(String text, {int maxCount}) {
    List<StockBasicInfo> list = [];
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

  static Future<bool> addStock(StockBasicInfo stockItem) async {
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

  static Future<Map<String, StockPrice>> updateStockPrice(String codes) {
    Completer<Map<String, StockPrice>> completer = Completer();
    String url = API_STOCK + codes;
    HttpUtil().getDio().get(url).then((response) {
      return completer.complete(_parseSinaData(response.data));
    });
    return completer.future;
  }

  static Map<String, StockPrice> _parseSinaData(String data) {
    logUtil.d("_parseSinaData : $data");
    Map<String, StockPrice> priceMap = {};
    if (data != null && data.isNotEmpty) {
      List<String> stockArray = data.trim().split(';');
      if (stockArray.isNotEmpty) {
        for (int i = 0; i < stockArray.length; ++i) {
          logUtil.d(stockArray[i]);
          StockPrice stockPrice = StockPrice();
          List<String> priceArray = stockArray[i].split(',');
          if (priceArray[0].length > 20) {
            stockPrice.loadSinaData(priceArray);
            String code =
                RegExp(r"(?<=hq_str_).*(?==)").stringMatch(priceArray[0]);
            priceMap[code] = stockPrice;
            logUtil.d('code===: $code');
          }
        }
      }
    }
    return priceMap;
  }
}
