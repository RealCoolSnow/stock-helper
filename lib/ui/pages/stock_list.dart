import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_status_bar/flutter_status_bar.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/bean/stock_price.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/sqflite/sql_table_data.dart';
import 'package:stock_helper/storage/sqflite/sql_util.dart';
import 'package:stock_helper/ui/pages/stock_search.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/format_util.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:stock_helper/util/stock_util.dart';
import 'package:stock_helper/util/stock_website.dart';
import 'package:stock_helper/util/tray_util.dart';

class StockListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage>
    with WidgetsBindingObserver {
  var sql = SqlUtil.setTable(SqlTable.NAME_STOCKS);
  List<StockInfo> stocklist = [];
  Map<String, StockPrice> stockPriceMap = {}; //缓存价格信息
  String stockCodeString = ''; //股票代码列表
  bool timerRunning = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //---load all stocks
    StockUtil.loadAllStocks(context);
    _loadShownStockList();
    //---tray icon
    Future.delayed(Duration.zero, () {
      TrayUtil.refreshState(I18n.of(context).text('app_name'));
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logUtil.d('didChangeAppLifecycleState: ${state.toString()}');
  }

  _loadShownStockList() {
    stockCodeString = '';
    sql.rawQuery("SELECT * FROM ${SqlTable.NAME_STOCKS} ORDER BY ID DESC",
        []).then((value) {
      logUtil.d(value);
      var list = value
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
      setState(() {
        stocklist = list;
      });
      logUtil.d('stockCodes $stockCodeString');
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(I18n.of(context).text("app_name")),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: I18n.of(context).text("setting"),
              onPressed: () =>
                  Config.router.navigateTo(context, Routes.setting),
            ),
          ],
        ),
        floatingActionButton: _buildActionButton(),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loadShownStockList();
            });
          },
          child: ListView(
            children: this._getStockList(),
          ),
        ));
  }

  List<Widget> _getStockList() {
    return stocklist.map((item) {
      return _buildStockItem(item);
    }).toList();
  }

  Widget _buildActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _addStock();
      },
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
      dense: true,
      onTap: () => _showStock(stockInfo),
      onLongPress: () => _delStock(stockInfo),
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

  void _addStock() {
    logUtil.d("_addStock");
    showSearch(
            context: context,
            delegate: StockSearchDelegate(
                hintText: I18n.of(context).text('search_tip')))
        .then((value) {
      logUtil.d('showSearch result: $value');
      if (value != null) {
        _loadShownStockList();
      }
    });
  }

  void _delStock(StockInfo stockInfo) {
    DialogUtil.showMessage(context, stockInfo.baseInfo.name,
        I18n.of(context).text('del_stock_tip'),
        negativeText: I18n.of(context).text('cancel'),
        positiveText: I18n.of(context).text('delete'), positiveCallback: () {
      Navigator.pop(context);
      sql.delete('id', stockInfo.baseInfo.id).then((value) {
        logUtil.d('delete result: $value');
        setState(() {
          stocklist.remove(stockInfo);
        });
      }).catchError((err) {
        logUtil.d(err);
      });
    });
  }

  void _showStock(StockInfo stockInfo) {
    StockWebSiteUtil.showStockInfo(stockInfo.baseInfo.code);
  }

  void _updateStockInfo() {
    StockUtil.updateStockPrice(stockCodeString).then((pricesMap) {
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

  void _testDatabase() {
    var sql = SqlUtil.setTable(SqlTable.NAME_STOCKS);
    //插入
    // var map = {'code': '601360', 'name': '三六零'};
    // sql.insert(map).then((id) {
    //   logUtil.d('insert $id');
    // });
    //删除
    sql.delete('id', 1);
    //查询
    var conditions = {};
    sql
        .query(conditions: conditions)
        .then((value) => logUtil.d('result $value'));
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
