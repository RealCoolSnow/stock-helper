/// 实时行情信息
class StockInfo {
  String code;
  String name;
  double price;
  double priceOpen;
  double priceClose;

  StockInfo(Map<dynamic, String> map,
      {this.code, this.name, this.price, this.priceOpen, this.priceClose});

  StockInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    price = json['price'];
    priceOpen = json['price_open'];
    priceClose = json['price_close'];
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_open'] = this.priceOpen;
    data['price_close'] = this.priceClose;
    return data;
  }
}
