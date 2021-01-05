import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/util/log_util.dart';

class StockList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: this._getStockList(),
      ),
    );
  }

  List<Widget> _getStockList() {
    List<StockInfo> stocklist = [
      StockInfo.fromJson(jsonDecode(
          '{"code":"601360","name":"三六零","price":15.3,"price_open":15.7}')),
      StockInfo.fromJson(jsonDecode(
          '{"code":"002340","name":"格林美","price":7.99,"price_open":7.94}')),
      StockInfo.fromJson(jsonDecode(
          '{"code":"002594","name":"比亚迪","price":206.00,"price_open":212.58}')),
      StockInfo.fromJson(jsonDecode(
          '{"code":"600519","name":"贵州茅台","price":2044.90,"price_open":1990.00}'))
    ];
    return stocklist.map((item) {
      return StockItem(item);
    }).toList();
  }
}

class StockItem extends StatelessWidget {
  StockItem(this.stockInfo);

  final StockInfo stockInfo;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.stockInfo.name),
      subtitle: Text(this.stockInfo.code),
      trailing: Text(
        '${this.stockInfo.price}',
        style: TextStyle(
            color: this.stockInfo.price > this.stockInfo.priceOpen
                ? Colors.red
                : Colors.green),
      ),
    );
  }
}
