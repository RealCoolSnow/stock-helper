/// 实时行情信息
class StockInfo {
  String code;
  String name;
  double price = 0;
  double priceOpen = 0;
  double priceClose = 0;

  StockInfo(Map<dynamic, String> map,
      {this.code, this.name, this.price, this.priceOpen, this.priceClose});

  StockInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    price = json['price'] != null ? json['price'] : 0;
    priceOpen = json['price_open'] != null ? json['price_open'] : 0;
    priceClose = json['price_close'] != null ? json['price_close'] : 0;
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
