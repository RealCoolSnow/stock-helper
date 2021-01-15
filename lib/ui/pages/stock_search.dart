import 'package:flutter/material.dart';
import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/bean/stock_info.dart';
import 'package:stock_helper/util/stock_util.dart';

class StockSearchDelegate extends SearchDelegate<StockInfo> {
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
        close(_context, StockInfo.baseInfo(stockItem));
      },
    );
  }
}
