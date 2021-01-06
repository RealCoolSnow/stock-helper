/// 股票基础信息
class StockBasicInfo {
  int id;
  String code;
  String name;

  StockBasicInfo({this.id, this.code, this.name});

  StockBasicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.parse(json['id']);
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
