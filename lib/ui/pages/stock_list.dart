import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/storage/sqflite/sql_table_data.dart';
import 'package:stock_helper/storage/sqflite/sql_util.dart';
import 'package:stock_helper/ui/pages/stock_search.dart';
import 'package:stock_helper/util/format_util.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:stock_helper/util/stock_util.dart';

class _StockItem extends StatelessWidget {
  _StockItem(this.stockInfo);

  final StockInfo stockInfo;
  @override
  Widget build(BuildContext context) {
    String percent = FormatUtil.get2FixedNumber(
        (this.stockInfo.price - this.stockInfo.priceOpen) /
            this.stockInfo.priceOpen *
            100);
    return ListTile(
      dense: true,
      title: Text(this.stockInfo.name),
      subtitle: Text(this.stockInfo.code),
      trailing: Container(
        width: 200,
        child: Row(
          children: [
            Text(
              '${this.stockInfo.price}',
              style: TextStyle(
                  color: this.stockInfo.price > this.stockInfo.priceOpen
                      ? Colors.red
                      : Colors.green),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                  color: this.stockInfo.price > this.stockInfo.priceOpen
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
}

class StockListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  var sql = SqlUtil.setTable(SqlTable.NAME_STOCKS);
  List<StockInfo> stocklist = [];
  @override
  void initState() {
    super.initState();
    //---load all stocks
    StockUtil.loadAllStocks(context);
    //---
    sql.rawQuery("SELECT * FROM ${SqlTable.NAME_STOCKS} ORDER BY ID DESC",
        []).then((value) {
      logUtil.d(value);
      var list = value
          .map((item) => StockInfo.fromJson(item))
          .toList()
          .cast<StockInfo>();
      setState(() {
        stocklist = list;
      });
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
        body: Container(
          child: ListView(
            children: this._getStockList(),
          ),
        ));
  }

  List<Widget> _getStockList() {
    // List<StockInfo> stocklist = [
    //   StockInfo.fromJson(jsonDecode(
    //       '{"code":"601360","name":"三六零","price":15.3,"price_open":15.7}')),
    //   StockInfo.fromJson(jsonDecode(
    //       '{"code":"002340","name":"格林美","price":7.99,"price_open":7.94}')),
    //   StockInfo.fromJson(jsonDecode(
    //       '{"code":"002594","name":"比亚迪","price":206.00,"price_open":212.58}')),
    //   StockInfo.fromJson(jsonDecode(
    //       '{"code":"600519","name":"贵州茅台","price":2044.90,"price_open":1990.00}'))
    // ];
    return stocklist.map((item) {
      return _StockItem(item);
    }).toList();
  }

  Widget _buildActionButton() {
    return FloatingActionButton(
      onPressed: _addStock,
      tooltip: I18n.of(context).text("add_stock"),
      child: Icon(Icons.add),
    );
  }

  void _addStock() {
    logUtil.d("_addStock");
    // StockInfo info =
    //     StockInfo.fromJson(jsonDecode('{"code":"601360","name":"三六零"}'));
    // logUtil.d(info.toJson());
    //_testDatabase();
    showSearch(
        context: context,
        delegate:
            StockSearchDelegate(hintText: I18n.of(context).text('search_tip')));
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
}
