import 'package:stock_helper/app_sentry.dart';
import 'package:stock_helper/ui/app.dart';

void main() => AppSentry.runWithCatchError(App());
