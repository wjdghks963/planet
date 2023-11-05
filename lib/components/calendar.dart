import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planet/screen/diary/diary.dart';
import 'package:planet/screen/diary/diary_form.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/calendar/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat format = CalendarFormat.month;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  late String _selectedDay;
  late DateTime _focusedDay;

  Map<String, List<CalendarEvent>> events = {
    "2023-11-01": [
      CalendarEvent('title'),
    ],
    "2023-11-02": [
      CalendarEvent('title'),
    ],
    //DateTime.utc(2023, 11, 2): [CalendarEvent('title3')],
  };

  List<Object> _getEventsForDay(DateTime day) {
    return events[dateFormat.format(day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = dateFormat.format(DateTime.now());
    _focusedDay = DateTime.now();
  }

  Future? route(String selectedDay) {
    if (events[selectedDay] != null) {
     return Get.to(() => Diary(),
          transition: Transition.rightToLeft,
          arguments: {'date': _selectedDay});
    }
    return Get.to(() => const DiaryForm(),
        transition: Transition.rightToLeft, arguments: {'date': _selectedDay});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        focusedDay: DateTime.now(),
        // TODO:: firstDay는 plant 첫 생성일
        firstDay: DateTime.utc(2022, 11, 4),
        lastDay: DateTime.now(),
        locale: 'ko_KR',
        daysOfWeekHeight: 30,
        eventLoader: _getEventsForDay,
        calendarStyle: const CalendarStyle(
            markerSize: 15,
            markerDecoration: BoxDecoration(
                color: ColorStyles.mainAccent, shape: BoxShape.circle)),
        onFormatChanged: (CalendarFormat format) {
          setState(() {
            this.format = format;
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = dateFormat.format(selectedDay);
            _focusedDay = focusedDay;
            route(_selectedDay);
          });
        },
      ),
    );
  }
}
