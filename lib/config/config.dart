import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';

class Config {
  /// debug flag
  static const bool debug = !kReleaseMode;
  static const String app = "stock_helper";
  static const String version = "1.0.2";
  static const int searchShowCount = 20;
  static const int stockTimerDuration = 2500;
  static FluroRouter router;
}
