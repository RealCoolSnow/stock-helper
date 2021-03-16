import 'package:stock_helper/bean/stock_basic_info.dart';
import 'package:stock_helper/bean/stock_price_tx.dart';

/// 实时行情信息
class StockInfo {
  StockBasicInfo baseInfo;
  StockPriceTX priceInfo = StockPriceTX();

  StockInfo.baseInfoFromJson(Map<String, dynamic> json) {
    baseInfo = StockBasicInfo.fromJson(json);
  }
  StockInfo.baseInfo(StockBasicInfo info) {
    baseInfo = info;
  }
}
