import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String formatBasedOnLocale(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final pattern = locale == 'en' ? 'MM/dd/yyyy, HH:mm' : 'dd/MM/yyyy, HH:mm';

    return DateFormat(pattern).format(date);
  }
}
