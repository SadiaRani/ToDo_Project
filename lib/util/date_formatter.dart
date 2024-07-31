

import 'package:intl/intl.dart';
import 'package:todoapp/util/date_formatter.dart';


String dateFormatted(){
  var now = DateTime.now();
  var formatter = DateFormat("EEE,MMM d,''yy");
  String formatted = formatter.format(now);
  return formatted;

}