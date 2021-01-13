import 'package:flutter_status_bar/flutter_status_bar.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/storage/Pref.dart';

class TrayUtil {
  static void refreshState(String initText) {
    Pref.getBool(PrefKey.settingTrayIcon).then((value) {
      if (value) {
        FlutterStatusBar.showStatusBar(initText);
      } else {
        FlutterStatusBar.hideStatusBar();
      }
    });
  }

  static void setText(String text) {
    FlutterStatusBar.setStatusBarText(text);
  }
}
