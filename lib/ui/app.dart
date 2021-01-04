import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stock_helper/config/config.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/locale/locale_util.dart';
import 'package:stock_helper/ui/app_theme.dart';
import 'package:stock_helper/ui/pages/home.dart';

class App extends StatefulWidget {
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
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
      home: HomePage(),
    );
    return app;
  }
}
