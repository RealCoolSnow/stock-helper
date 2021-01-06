import 'package:flustars/flustars.dart';

class FormatUtil {
  static String get2FixedNumber(double n) {
    if (n.isNaN) {
      return "0";
    }
    return (NumUtil.getNumByValueDouble(n, 2)).toStringAsFixed(2);
  }
}
