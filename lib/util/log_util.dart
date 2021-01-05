/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 15:08:20
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:57:36
 */
import 'package:logger/logger.dart';

///
/// Usage:
///
/// logUtil.d('abc');
/// logUtil.d2('abc'); //no stack
///
class LogUtil {
  bool enabled = true;

  /// normal logger
  var logger = Logger(
    printer: PrettyPrinter(printTime: true),
  );

  /// no stack logger
  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0, printTime: true),
  );
  static final LogUtil _instance = new LogUtil._internal();
  factory LogUtil() {
    return _instance;
  }

  LogUtil._internal();
  void setEnabled(bool enabled) {
    this.enabled = enabled;
  }

  void v(dynamic v) {
    if (enabled) {
      logger.v(v);
    }
  }

  void d(dynamic v) {
    if (enabled) {
      logger.d(v);
    }
  }

  void i(dynamic v) {
    if (enabled) {
      logger.i(v);
    }
  }

  void w(dynamic v) {
    if (enabled) {
      logger.w(v);
    }
  }

  void e(dynamic v) {
    if (enabled) {
      logger.e(v);
    }
  }

  void v2(dynamic v) {
    if (enabled) {
      loggerNoStack.v(v);
    }
  }

  void d2(dynamic v) {
    if (enabled) {
      loggerNoStack.d(v);
    }
  }

  void i2(dynamic v) {
    if (enabled) {
      loggerNoStack.i(v);
    }
  }

  void w2(dynamic v) {
    if (enabled) {
      loggerNoStack.w(v);
    }
  }

  void e2(dynamic v) {
    if (enabled) {
      loggerNoStack.e(v);
    }
  }
}

LogUtil logUtil = new LogUtil();
