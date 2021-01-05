import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';

class AboutPage extends StatefulWidget {
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(I18n.of(context).text("about")),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(I18n.of(context).text("about"))));
  }
}
