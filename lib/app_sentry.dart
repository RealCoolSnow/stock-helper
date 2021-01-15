import 'dart:async';

import 'package:flutter/widgets.dart';

const bool inProduction = bool.fromEnvironment("dart.vm.product");

class AppSentry {
  static void runWithCatchError(Widget appMain) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (!inProduction) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
    runZonedGuarded<Future<Null>>(() async {
      runApp(appMain);
    }, (error, stackTrace) async {
      _reportError(error, stackTrace);
    });
  }

  static Future<void> _reportError(dynamic error, dynamic stackTrace) async {
    if (!inProduction) {
      print(stackTrace);
    }
    //then, report to your server
  }
}
