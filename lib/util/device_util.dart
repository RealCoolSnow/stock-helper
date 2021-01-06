/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 18:39:18
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:57:32
 */
import 'dart:io';

class DeviceUtil {
  ///
  static bool isMobile() {
    var ret = false;
    try {
      ret = Platform.isIOS || Platform.isAndroid;
    } catch (e) {
      ret = false;
    }
    return ret;
  }

  static String getName() {
    String ret = 'unknown';
    try {
      ret = Platform.operatingSystem;
    } catch (e) {
      print(e);
    }
    return ret;
  }
}
