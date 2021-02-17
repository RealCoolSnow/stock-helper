class StockPrice {
  double open = 0; //1-今日开盘价
  double yesterdayClose = 0; //2-昨日收盘价
  double price = 0; //3-当前价格
  String priceStr = ''; //3-当前价格(字符串)
  double high = 0; //4-今日最高价
  double low = 0; //5-今日最低价
  double buy = 0; //6-竞买价，即“买一”报价
  double sell = 0; //7-竞卖价，即“卖一”报价；
  int transactionCount = 0; //8-成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
  double transactionAmount =
      0; //9-成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
  int buyCount1 = 0; //10-“买一”申请4695股，即47手；
  double buyPrice1 = 0; //11-“买一”报价；
  int buyCount2 = 0; //12-买二
  double buyPrice2 = 0; //13-买二
  int buyCount3 = 0; //14-买三
  double buyPrice3 = 0; //15-买三
  int buyCount4 = 0; //16-买四
  double buyPrice4 = 0; //17-买四
  int buyCount5 = 0; //18-买五
  double buyPrice5 = 0; //19-买五
  int sellCount1 = 0; //20-“卖一”申报3100股，即31手；
  double sellPrice1 = 0; //21-“卖一”报价
  int sellCount2 = 0; //22-卖二
  double sellPrice2 = 0; //23-卖二
  int sellCount3 = 0; //24-卖三
  double sellPrice3 = 0; //25-卖三
  int sellCount4 = 0; //26-卖四
  double sellPrice4 = 0; //27-卖四
  int sellCount5 = 0; //28-卖五
  double sellPrice5 = 0; //29-卖五
  String date = ''; //30-日期
  String time = ''; //31-时间

  void loadSinaData(List<String> data) {
    if (data.isNotEmpty && data.length >= 32) {
      open = double.parse(data[1]);
      yesterdayClose = double.parse(data[2]);
      price = double.parse(data[3]);
      priceStr = price.toStringAsFixed(2);
      high = double.parse(data[4]);
      low = double.parse(data[5]);
      buy = double.parse(data[6]);
      sell = double.parse(data[7]);
      transactionCount = int.parse(data[8]);
      transactionAmount = double.parse(data[9]);
      buyCount1 = int.parse(data[10]);
      buyPrice1 = double.parse(data[11]);
      buyCount2 = int.parse(data[12]);
      buyPrice2 = double.parse(data[13]);
      buyCount3 = int.parse(data[14]);
      buyPrice3 = double.parse(data[15]);
      buyCount4 = int.parse(data[16]);
      buyPrice4 = double.parse(data[17]);
      buyCount5 = int.parse(data[18]);
      buyPrice5 = double.parse(data[19]);
      sellCount1 = int.parse(data[20]);
      sellPrice1 = double.parse(data[21]);
      sellCount2 = int.parse(data[22]);
      sellPrice2 = double.parse(data[23]);
      sellCount3 = int.parse(data[24]);
      sellPrice3 = double.parse(data[25]);
      sellCount4 = int.parse(data[26]);
      sellPrice4 = double.parse(data[27]);
      sellCount5 = int.parse(data[28]);
      sellPrice5 = double.parse(data[29]);
      date = data[30];
      time = data[31];
    }
  }

  /**
   * 港股信息
   * 
   * http://hq.sinajs.cn/list=hk00001
var hq_str_hk00001="CHEUNG KONG,长和,90.300,91.050,91.050,90.000,90.750,-0.300,-0.329,90.650,90.750,627798876,6932826,2.954,2.810,118.800,87.600,2016/06/22,16:01";

temp[0]------CHEUNG KONG------名称
temp[1]------长和------股票名称
temp[2]------90.300------今日开盘价
temp[3]------91.050------昨日收盘价
temp[4]------91.050------最高价
temp[5]------90.000------最低价
temp[6]------90.750------当前价（现价）
temp[7]------ -0.300------涨跌
temp[8]------ -0.329------涨幅
temp[9]------90.650------买一
temp[10]------90.750------卖一
temp[11]------627798876------成交额
temp[12]------6932826------成交量
temp[13]------2.954------市盈率
temp[14]------2.810------周息率（2.810%）
temp[15]------118.800------52周最高
temp[16]------87.600------52周最低
temp[17]------2016/06/22------日期
temp[18]------16:01------时间
   */
  void loadHKData(List<String> data) {
    if (data.isNotEmpty && data.length > 18) {
      open = double.parse(data[2]); //今日开盘价
      yesterdayClose = double.parse(data[3]); //昨日收盘价
      high = double.parse(data[4]); //最高价
      low = double.parse(data[5]); //最低价
      price = double.parse(data[6]); //当前价（现价）
      priceStr = price.toStringAsFixed(2);
      buyPrice1 = double.parse(data[9]); //买一
      sellPrice1 = double.parse(data[10]); //卖一
      date = data[17];
      time = data[18];
    }
  }
}
