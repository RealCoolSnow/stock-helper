/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 14:22:39
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:57:39
 */
import 'package:intl/intl.dart';

///
/// Time Util
///
class TimeUtil {
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static String format(DateTime dateTime,
      {String format = "yyyy-MM-dd HH:mm:ss"}) {
    return DateFormat(format).format(dateTime);
  }
}
