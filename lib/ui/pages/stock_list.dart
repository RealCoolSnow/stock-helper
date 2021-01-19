import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_status_bar/flutter_status_bar.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/bean/stock_price.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/Pref.dart';
import 'package:stock_helper/ui/pages/stock_search.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/format_util.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:stock_helper/util/stock_util.dart';
import 'package:stock_helper/util/stock_website.dart';
import 'package:stock_helper/util/tray_util.dart';
import 'package:stock_helper/util/update_util.dart';

class StockListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  List<StockInfo> stocklist = [];
  Map<String, StockPrice> stockPriceMap = {}; //缓存价格信息
  String stockCodeString = ''; //股票代码列表
  bool timerRunning = false;
  bool requesting = false;
  @override
  void initState() {
    super.initState();
    //---load all stocks
    StockUtil.loadAllStocks(context);
    //---check update
    UpdateUtil.checkUpdate(context);
    _loadShownStockList();
    //---tray icon
    Future.delayed(Duration.zero, () {
      TrayUtil.refreshState(I18n.of(context).text('app_name'));
    });
    _startTimer();
  }

  _loadShownStockList() {
    stockCodeString = '';
    Pref.getString(PrefKey.stockListOrder, "").then((data) {
      if (data != null && data.isNotEmpty) {
        List listJson = json.decode(data);
        if (listJson != null && listJson.isNotEmpty) {
          var list = listJson
              .map((item) {
                stockCodeString += item['code'] + ',';
                StockInfo stockInfo = StockInfo.baseInfoFromJson(item);
                if (stockPriceMap.containsKey(item['code'])) {
                  stockInfo.priceInfo = stockPriceMap[item['code']];
                }
                return stockInfo;
              })
              .toList()
              .cast<StockInfo>();
          ;
          setState(() {
            stocklist = list;
          });
          logUtil.d('stockCodes $stockCodeString');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(I18n.of(context).text("app_name")),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   tooltip: I18n.of(context).text("add_stock"),
            //   onPressed: _addStock,
            // ),
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: I18n.of(context).text("setting"),
              onPressed: () =>
                  Config.router.navigateTo(context, Routes.setting),
            ),
          ],
        ),
        floatingActionButton: _buildActionButton(),
        body: stocklist.isNotEmpty
            ? ReorderableListView(
                children: this._getStockList(),
                onReorder: (int oldIndex, int newIndex) =>
                    _updateListOrder(oldIndex, newIndex))
            : Center(child: Text(I18n.of(context).text("add_stock_tip"))));
  }

  void _updateListOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var child = stocklist.removeAt(oldIndex);
    stocklist.insert(newIndex, child);
    setState(() {});
    StockUtil.saveListOrder(stocklist);
  }

  List<Widget> _getStockList() {
    return stocklist.map((item) {
      return _buildStockItem(item);
    }).toList();
  }

  Widget _buildActionButton() {
    return FloatingActionButton(
      onPressed: _addStock,
      tooltip: I18n.of(context).text("add_stock"),
      child: Icon(Icons.add),
    );
  }

  Widget _buildStockItem(StockInfo stockInfo) {
    String percent = FormatUtil.get2FixedNumber(
        (stockInfo.priceInfo.price - stockInfo.priceInfo.yesterdayClose) /
            stockInfo.priceInfo.yesterdayClose *
            100);
    return ListTile(
      key: ValueKey(stockInfo.baseInfo.code),
      dense: true,
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => _showActionSheet(stockInfo),
        ).then((value) {});
      },
      // onLongPress: () => _delStock(stockInfo),
      title: Text(stockInfo.baseInfo.name),
      subtitle: Text(stockInfo.baseInfo.code),
      trailing: Container(
        width: 200,
        child: Row(
          children: [
            Text(
              '${stockInfo.priceInfo.priceStr}',
              style: TextStyle(
                  color: stockInfo.priceInfo.price >
                          stockInfo.priceInfo.yesterdayClose
                      ? Colors.red
                      : Colors.green),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                  color: stockInfo.priceInfo.price >
                          stockInfo.priceInfo.yesterdayClose
                      ? Colors.red
                      : Colors.green),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
        ),
      ),
    );
  }

  Widget _showActionSheet(StockInfo stockInfo) {
    return CupertinoActionSheet(
      title: Text(
        stockInfo.baseInfo.name,
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            I18n.of(context).text('view'),
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _showStock(stockInfo);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            I18n.of(context).text('delete'),
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _delStock(stockInfo);
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text(
          I18n.of(context).text('cancel'),
          style: TextStyle(
            fontSize: 13.0,
            color: const Color(0xFF666666),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _addStock() {
    logUtil.d("_addStock");
    showSearch(
            context: context,
            delegate: StockSearchDelegate(
                hintText: I18n.of(context).text('search_tip')))
        .then((stockInfo) {
      logUtil.d('showSearch result: $stockInfo');
      if (stockInfo != null) {
        setState(() {
          if (!stockCodeString.contains(stockInfo.baseInfo.code)) {
            stocklist.insert(0, stockInfo);
            stockCodeString = '${stockInfo.baseInfo.code},$stockCodeString';
            StockUtil.saveListOrder(stocklist);
          }
        });
      }
    });
  }

  void _delStock(StockInfo stockInfo) {
    DialogUtil.showMessage(context, stockInfo.baseInfo.name,
        I18n.of(context).text('del_stock_tip'),
        negativeText: I18n.of(context).text('cancel'),
        positiveText: I18n.of(context).text('delete'), positiveCallback: () {
      Navigator.pop(context);
      setState(() {
        stocklist.remove(stockInfo);
        stockCodeString =
            stockCodeString.replaceAll('${stockInfo.baseInfo.code},', '');
        StockUtil.saveListOrder(stocklist);
      });
    });
  }

  void _showStock(StockInfo stockInfo) {
    StockWebSiteUtil.showStockInfo(stockInfo.baseInfo.code);
  }

  void _updateStockInfo() {
    if (requesting || stocklist.isEmpty || stockCodeString.isEmpty) {
      return;
    }
    requesting = true;
    StockUtil.updateStockPrice(stockCodeString).then((pricesMap) {
      requesting = false;
      if (pricesMap != null && pricesMap.isNotEmpty) {
        setState(() {
          for (int i = 0; i < stocklist.length; i++) {
            if (pricesMap.containsKey(stocklist[i].baseInfo.code)) {
              stocklist[i].priceInfo = pricesMap[stocklist[i].baseInfo.code];
            }
          }
          stockPriceMap = pricesMap;
        });
        _updateStatusBar();
      }
    });
  }

  void _updateStatusBar() {
    FlutterStatusBar.isShown().then((value) {
      logUtil.d('isShown $value');
      String text = "";
      if (stocklist.length > 0) {
        text += '${stocklist[0].priceInfo.priceStr}';
      }
      if (stocklist.length > 1) {
        text += ' ${stocklist[1].priceInfo.priceStr}';
      }
      if (stocklist.length > 2) {
        text += ' ${stocklist[2].priceInfo.priceStr}';
      }
      if (text.isNotEmpty) {
        FlutterStatusBar.setStatusBarText(text);
      }
    });
  }

  void _startTimer() {
    if (!timerRunning) {
      timerRunning = true;
      _updateStockInfo();
      Timer.periodic(Duration(milliseconds: Config.stockTimerDuration),
          (timer) {
        if (!timerRunning) {
          timer.cancel();
        } else {
          _updateStockInfo();
        }
      });
    }
  }

  void _stopTimer() {
    timerRunning = false;
  }
}
