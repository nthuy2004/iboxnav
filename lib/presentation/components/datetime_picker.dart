import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iboxnav/controllers/widget/datetime_controller.dart';
import 'package:iboxnav/core/utils/utility.dart';

typedef DatetimePickerWidget = Widget Function(
    BuildContext context, DatetimePickerController controller);

// ignore: must_be_immutable
class DatetimePicker extends StatefulWidget {
  DatetimePickerController controller;
  String helper;
  DatetimePicker({required this.controller, this.helper = "Select date"});
  DatetimePickerWidget? widgetCb;

  ///Implement datetimepicker in custom widget :)))
  factory DatetimePicker.Custom(
      DatetimePickerController controller, DatetimePickerWidget widgetCb) {
    var a = DatetimePicker(controller: controller);
    a.widgetCb = widgetCb;
    return a;
  }
  @override
  State<DatetimePicker> createState() => _DatetimePickerState();
}

class _DatetimePickerState extends State<DatetimePicker> {
  DateTime _dateState = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.controller.date,
        firstDate: DateTime(2011, 8),
        lastDate: DateTime.now());
    if (picked != null) {
      final TimeOfDay? timed = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(widget.controller.date));
      if (timed != null) {
        widget.controller.setDate(picked);
        widget.controller.setTime(timed);
      }
    }
  }

  @override
  void initState() {
    _dateState = widget.controller.date;
    widget.controller.addListener(() {
      setState(() {
        _dateState = widget.controller.date;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.widgetCb == null) {
      return _base(context);
    } else {
      return InkWell(
          child: widget.widgetCb!(context, widget.controller),
          onTap: () => _selectDate(context));
    }
  }

  Column _base(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            widget.helper,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.only(
              left: 13,
              top: 15,
              right: 13,
              bottom: 15,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey[300]!,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${Utility.formatDatetime(_dateState)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/img_calendar.svg",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
