import 'package:flutter/material.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/core/utils/utility.dart';

class DatetimePickerController extends ChangeNotifier {
  DateTime date;
  String format;
  DatetimePickerController(
      {required this.date, this.format = Constants.DATETIME_FORMAT}) {
    setDate(date);
  }
  void setDate(DateTime date) {
    this.date = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    this.date = this.date.copyWith(hour: time.hour, minute: time.minute);

    notifyListeners();
  }

  @override
  String toString() {
    return Utility.formatDatetime(date, format: format);
  }

  int compareTo(DatetimePickerController _c2) {
    DateTime d1 = date;
    DateTime d2 = _c2.date;
    return d1.compareTo(d2);
  }
}
