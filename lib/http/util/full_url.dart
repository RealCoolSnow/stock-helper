/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 18:34:12
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:58:23
 */

import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/locale/locale_util.dart';
import 'package:stock_helper/util/device_util.dart';
import 'package:stock_helper/util/time_util.dart';

class FullUrl {
  static String make(String url, Map<String, String> params) {
    var u = url;
    if (u.contains('?')) {
      u += ('&platform=' + DeviceUtil.getName());
    } else {
      u += ('?platform=' + DeviceUtil.getName());
    }
    u += ('&app=' + Config.app);
    u += ('&lang=' + localeUtil.getLanguageCode());
    //u += ('&uid=' + Config.uid);
    if (params != null && params.length > 0) {
      params.forEach((String key, String value) {
        var v = Uri.encodeComponent(value);
        u += ('&$key=$v');
      });
    }
    u += ('&t=' + TimeUtil.currentTimeMillis().toString());
    return u;
  }
}
