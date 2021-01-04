import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/ui/pages/home/setting.dart';
import 'package:stock_helper/ui/pages/home/stock_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(I18n.of(context).text('app_name')),
      actions: <Widget>[],
      bottom: _buildTabBar(),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      indicatorColor: Colors.white,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.home)),
        Tab(icon: Icon(Icons.settings)),
      ],
    );
  }

  Widget _buildBody() {
    return TabBarView(children: [StockList(), Setting()]);
  }
}
