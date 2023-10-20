import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import './utils.dart';

List<Event> _getEventsForDay(DateTime day) {
  // Implementation example
  return kEvents[day] ?? [];
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TimeOfDay startingTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime startDateTime = DateTime.now();
  DateTime? endDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023),
            lastDay: DateTime(2024),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              debugPrint(selectedDay.toString());
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
          ),
          const Spacer(
            flex: 3,
          ),
          FilledButton(
            onPressed: () async {
              TimeOfDay? newStartingTime = await showTimePicker(
                  context: context,
                  initialTime: startingTime,
                  helpText: "Select Starting Time");
              TimeOfDay? newEndTime = await showTimePicker(
                  context: context,
                  initialTime: endTime,
                  helpText: "Select End Time");
              if (newStartingTime != null) {
                setState(() {
                  startingTime = newStartingTime;
                  timeToMinutes(startingTime);
                });
                if (newEndTime != null) {
                  setState(() {
                    endTime = newEndTime;
                    timeToMinutes(endTime);
                  });
                }
              }
            },
            child: const Text('Button'),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}

timeToMinutes(TimeOfDay time) {
  var timeStr = time.toString();

  var hoursInt = int.parse(timeStr.substring(10, 12));
  hoursInt = hoursInt * 60;
  var minutesInt = int.parse(timeStr.substring(13, 15));
  minutesInt = minutesInt + hoursInt;
  debugPrint(minutesInt.toString());
  return (minutesInt);
}

writeToCSV(data, File file) async {
  if (!await file.exists()){
    file.create(recursive: true);
  }
  file.writeAsString(data);
}

checkForFile(path){
  File file = File(path);
  return file.exists();
}