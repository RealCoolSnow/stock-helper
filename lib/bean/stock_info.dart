import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/bean/stock_price.dart';

/// 实时行情信息
class StockInfo {
  StockBasicInfo baseInfo;
  StockPrice priceInfo = StockPrice();

  StockInfo.baseInfoFromJson(Map<String, dynamic> json) {
    baseInfo = StockBasicInfo.fromJson(json);
  }
  StockInfo.baseInfo(StockBasicInfo info) {
    baseInfo = info;
  }
}
