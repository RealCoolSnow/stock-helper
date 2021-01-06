/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 18:28:03
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 14:24:51
 */
import 'package:dio/dio.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/util/log_util.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    if (Config.debug) {
      logUtil.d(err.toString());
    }
    return super.onError(err);
  }
}
