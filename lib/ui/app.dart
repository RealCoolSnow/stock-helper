import 'package:flutter/material.dart';
import 'package:stock_helper/config/config.dart';
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
      home: HomePage(title: Config.app),
    );
    return app;
  }
}
