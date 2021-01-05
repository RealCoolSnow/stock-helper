import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/config/pref_key.dart';
import 'package:stock_helper/config/route/routes.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/locale/locale_util.dart';
import 'package:stock_helper/storage/Pref.dart';
import 'package:stock_helper/ui/app_theme.dart';
import 'package:stock_helper/ui/pages/home.dart';
import 'package:stock_helper/util/log_util.dart';
import 'package:stock_helper/util/time_util.dart';

class App extends StatefulWidget {
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  _AppState() {
    //---router
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Config.router = router;
    //---shared preferences
    Pref.setString(PrefKey.launchTime, TimeUtil.format(DateTime.now()));
    //---logutil
    logUtil.setEnabled(Config.debug);
    Pref.getString(PrefKey.launchTime)
        .then((value) => logUtil.d("App created $value"));
  }
  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: Config.app,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: AppTheme.primary,
        splashColor: AppTheme.splash,
      ),
      localizationsDelegates: [
        const I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: localeUtil.supportedLocales(),
      onGenerateRoute: Config.router.generator,
      home: HomePage(),
    );
    return app;
  }
}
