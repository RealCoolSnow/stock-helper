class StockInfo {
  String code;
  String name;
  double price;
  double priceOpen;

  StockInfo({this.code, this.name, this.price, this.priceOpen});

  StockInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    price = json['price'];
    priceOpen = json['price_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_open'] = this.priceOpen;
    return data;
  }
}
