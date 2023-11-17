import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/diary/diary_detail_model.dart';
import 'package:planet/screen/diary/diary.dart';
import 'package:planet/screen/diary/diary_form.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/calendar/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final List<DiaryDetailModel>? diaries;
  final bool? mine;

  const CustomCalendar(this.diaries, this.mine, {super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat format = CalendarFormat.month;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  late String _selectedDay;
  late DateTime _focusedDay;

  Map<String, List<CalendarEvent>> events = {};

  List<Object> _getEventsForDay(DateTime day) {
    return events[dateFormat.format(day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = dateFormat.format(DateTime.now());
    _focusedDay = DateTime.now();
    _createEventsMap();
  }

  void _createEventsMap() {
    events.clear();
    for (var diary in widget.diaries ?? []) {
      final dateKey = diary.createdAt;
      if (events.containsKey(dateKey)) {
        events[dateKey]!.add(CalendarEvent(diary.content));
      } else {
        events[dateKey] = [CalendarEvent(diary.content)];
      }
    }
  }

  Future? route(String selectedDay) {
    final eventsOnDay = events[selectedDay];

    if (eventsOnDay != null && eventsOnDay.isNotEmpty) {
      final diary = eventsOnDay.first;

      if (diary.public || diary.mine) {
        // 일기가 공개되어 있거나, 내 일기인 경우
        return Get.to(() => Diary(),
            transition: Transition.rightToLeft,
            arguments: {'date': _selectedDay});
      }else{
        return Get.dialog(CustomAlertDialog(alertContent: "비공개 일지입니다."));

      }
    }

    if (widget.mine == true) {
      // 일기 작성 페이지로 이동
      return Get.to(() => const DiaryForm(),
          transition: Transition.rightToLeft,
          arguments: {'date': _selectedDay});
    }


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
