import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/ui/pages/home/setting.dart';
import 'package:stock_helper/ui/pages/home/stock_list.dart';

const int TAB_LENGTH = 2;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabSelected = 0;
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: TAB_LENGTH, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index.toDouble() == _tabController.animation.value) {
        setState(() {
          _tabSelected = _tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildActionButton(), // Thi
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
      controller: _tabController,
      indicatorColor: Colors.white,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.home)),
        Tab(icon: Icon(Icons.settings)),
      ],
    );
  }

  Widget _buildBody() {
    return TabBarView(
        controller: _tabController, children: [StockList(), Setting()]);
  }

  Widget _buildActionButton() {
    return _tabSelected == 0
        ? FloatingActionButton(
            onPressed: _addStock,
            tooltip: I18n.of(context).text("add_stock"),
            child: Icon(Icons.add),
          )
        : null;
  }

  void _addStock() {
    print('_addStock');
  }
}
