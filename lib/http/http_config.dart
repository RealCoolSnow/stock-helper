import 'dart:io';

class HttpConfig {
  static const String baseUrl = "https://www.joy666.cn/wxapi/stock";
  static final ContentType contentType = ContentType.json;
  static const connectTimeout = 30000;
  static const receiveTimeout = 30000;
}
