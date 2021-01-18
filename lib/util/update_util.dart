import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:stock_helper/http/http_util.dart';
import 'package:stock_helper/util/common_util.dart';
import 'package:stock_helper/util/dialog_util.dart';
import 'package:stock_helper/util/log_util.dart';

class UpdateUtil {
  static checkUpdate(BuildContext context) {
    HttpUtil().get('/check_update', getParams: {}).then((data) {
      logUtil.d('check_update $data');
      _isNeedUpdate(data).then((update) {
        if (update) {
          DialogUtil.showMessage(
              context, '发现新版本v${data['vname']}', data['hint'],
              positiveText: '更新', negativeText: '暂不', positiveCallback: () {
            CommonUtil.launchURL(data['url']);
          });
        }
      });
    }).catchError((error) {
      logUtil.d(error.message);
    });
  }

  static Future<bool> _isNeedUpdate(data) {
    Completer completer = new Completer<bool>();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      completer.complete(
          int.parse(packageInfo.buildNumber) < int.parse(data['vcode']));
    });
    return completer.future;
  }
}
