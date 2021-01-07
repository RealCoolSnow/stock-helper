import 'package:flutter/material.dart';
import 'package:stock_helper/locale/i18n.dart';
import 'package:stock_helper/ui/app_theme.dart';

enum Action { OK, Cancel }

class DialogUtil {
  static void showMessage(BuildContext context, String title, String message,
      {String positiveText,
      String negativeText,
      VoidCallback positiveCallback,
      VoidCallback negativeCallback}) {
    List<Widget> btns = [];
    if (negativeText != null && negativeText.isNotEmpty) {
      btns.add(MaterialButton(
        color: Colors.grey,
        textColor: Colors.white,
        onPressed: () => negativeCallback != null
            ? negativeCallback()
            : Navigator.pop(context, Action.Cancel),
        child: Text(negativeText),
      ));
    }
    btns.add(MaterialButton(
      color: AppTheme.primary,
      textColor: Colors.white,
      onPressed: () => positiveCallback != null
          ? positiveCallback()
          : Navigator.pop(context, Action.OK),
      child: Text((positiveText != null && positiveText.isNotEmpty)
          ? positiveText
          : I18n.of(context).text('ok')),
    ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: btns,
          );
        });
  }
}
