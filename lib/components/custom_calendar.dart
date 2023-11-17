import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/models/api/diary/diary_detail_model.dart';
import 'package:planet/screen/diary/diary.dart';
import 'package:planet/screen/diary/diary_form.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/calendar/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final List<DiaryDetailModel>? diaries;
  final bool? isMine;

  const CustomCalendar(this.diaries, this.isMine, {super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late SelectedPlantDetailController selectedPlantDetailController;

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

    selectedPlantDetailController = Get.find<SelectedPlantDetailController>();

  }

  void _createEventsMap() {
    events.clear();
    for (var diary in widget.diaries ?? []) {
      final dateKey = diary.createdAt;
      if (events.containsKey(dateKey)) {
        events[dateKey]!
            .add(CalendarEvent(isPublic: diary.isPublic, isMine: diary.isMine));
      } else {
        events[dateKey] = [
          CalendarEvent(isPublic: diary.isPublic, isMine: diary.isMine)
        ];
      }
    }
  }

  Future? goToDiaryDetail(String selectedDay) {
    final eventsOnDay = events[selectedDay];
print(eventsOnDay);
    if (eventsOnDay != null && eventsOnDay.isNotEmpty) {
      final diary = eventsOnDay.first;

      if (diary.isMine) {
        return Get.to(() => Diary(),
            transition: Transition.rightToLeft,
            arguments: {'date': _selectedDay});
      }

      if (diary.isPublic) {
        // 일기가 공개되어 있거나, 내 일기인 경우
        return Get.to(() => Diary(),
            transition: Transition.rightToLeft,
            arguments: {'date': _selectedDay});
      }

      if (diary.isMine == false && diary.isPublic == false) {
        return Get.dialog(CustomAlertDialog(alertContent: "비공개 일지입니다."));
      }
    }

    if(eventsOnDay == null && widget.isMine == true){
        // 일기 작성 페이지로 이동
        return Get.to(() => const DiaryForm(),
            transition: Transition.rightToLeft,
            arguments: {'date': _selectedDay});

    }



    return null;
  }

  @override
  Widget build(BuildContext context) {

    String createdAtString = selectedPlantDetailController.selectedPlant.createdAt!;
    DateTime firstDay = DateTime.parse(createdAtString);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        focusedDay: DateTime.now(),
        firstDay: firstDay,
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
            goToDiaryDetail(_selectedDay);
          });
        },
      ),
    );
  }
}
