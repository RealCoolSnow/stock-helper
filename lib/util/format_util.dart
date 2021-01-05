import 'package:flustars/flustars.dart';

class FormatUtil {
  static String get2FixedNumber(double n) {
    return (NumUtil.getNumByValueDouble(n, 2)).toStringAsFixed(2);
  }
}
