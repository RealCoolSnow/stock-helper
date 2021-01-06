import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:stock_helper/util/stock_util.dart';

class StockSearchDelegate extends SearchDelegate<StockBasicInfo> {
  BuildContext _context;
  StockSearchDelegate({
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _context = context;
    return _buildSearchContentView();
  }

  _buildSearchContentView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildSearchItemView()],
      ),
    );
  }

  _buildSearchItemView() {
    var list = StockUtil.searchStocks(this.query, maxCount: 20);
    return Container(
      child: Wrap(
        // runSpacing: 0,
        children: list
            .map((item) {
              return _buildSearchItem(item);
            })
            .toList()
            .cast<Widget>(),
      ),
    );
  }

  _buildSearchItem(StockBasicInfo stockItem) {
    return ListTile(
      dense: true,
      title: Text(stockItem.name),
      subtitle: Text(stockItem.code),
      onTap: () {
        logUtil.d(stockItem.toJson());
        StockUtil.addStock(stockItem);
        close(_context, stockItem);
      },
    );
  }
}
/*
class _SearchContentView extends StatefulWidget {
  final String query;
  const _SearchContentView({Key key, this.query}) : super(key: key);
  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<_SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchItemView(
            query: this.widget.query,
          )
        ],
      ),
    );
  }
}

class _SearchItemView extends StatefulWidget {
  final String query;
  const _SearchItemView({Key key, this.query}) : super(key: key);
  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<_SearchItemView> {
  List<StockItem> list = [];

  @override
  Widget build(BuildContext context) {
    list = StockUtil.searchStocks(this.widget.query, maxCount: 20);
    return Container(
      child: Wrap(
        // runSpacing: 0,
        children: list.map((item) {
          return _SearchItem(stockItem: item);
        }).toList(),
      ),
    );
  }
}

class _SearchItem extends StatefulWidget {
  @required
  final StockItem stockItem;
  const _SearchItem({Key key, this.stockItem}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<_SearchItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(this.widget.stockItem.name),
      subtitle: Text(this.widget.stockItem.code),
      onTap: () {
        logUtil.d(this.widget.stockItem.toJson());
        StockUtil.addStock(this.widget.stockItem);
      },
    );
  }
}
*/
