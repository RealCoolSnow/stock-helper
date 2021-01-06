import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/ui/app_theme.dart';

enum Action { OK, Cancel }

class DialogUtil {
  static void showMessage(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              MaterialButton(
                color: AppTheme.primary,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context, Action.OK),
                child: Text(I18n.of(context).text('ok')),
              ),
            ],
          );
        });
  }
}
