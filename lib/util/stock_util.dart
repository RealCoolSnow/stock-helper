import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/bean/stock_price.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/http/http_util.dart';
import 'package:stock_helper/storage/Pref.dart';
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

  static Future<Map<String, StockPrice>> updateStockPrice(String codes) {
    Completer<Map<String, StockPrice>> completer = Completer();
    String url = API_STOCK + codes;
    HttpUtil().getDio().get(url).then((response) {
      return completer.complete(_parseSinaData(response.data));
    });
    return completer.future;
  }

  static Future<bool> saveListOrder(List<StockInfo> stocklist) {
    Completer<bool> completer = Completer();
    List<StockBasicInfo> list = [];
    for (var i = 0; i < stocklist.length; i++) {
      list.add(stocklist[i].baseInfo);
    }
    String data = json.encode(list);
    logUtil.d('saveListOrder $data');
    Pref.setString(PrefKey.stockListOrder, data)
        .then((value) => completer.complete(true));
    return completer.future;
  }

  static Map<String, StockPrice> _parseSinaData(String data) {
    logUtil.d("_parseSinaData : $data");
    Map<String, StockPrice> priceMap = {};
    if (data != null && data.isNotEmpty) {
      List<String> stockArray = data.trim().split(';');
      if (stockArray.isNotEmpty) {
        for (int i = 0; i < stockArray.length; ++i) {
          StockPrice stockPrice = StockPrice();
          List<String> priceArray = stockArray[i].split(',');
          if (priceArray[0].length > 20) {
            stockPrice.loadSinaData(priceArray);
            String code =
                RegExp(r"(?<=hq_str_).*(?==)").stringMatch(priceArray[0]);
            priceMap[code] = stockPrice;
          }
        }
      }
    }
    return priceMap;
  }
}
