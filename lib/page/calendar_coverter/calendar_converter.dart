// Copyright 2025 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: GPL-2.0-or-later

import 'package:cmcalc/calculator_bridge/calendar_bridge.g.dart';
import 'package:cmcalc/page/calendar_coverter/calendar_converter_static.dart';
import 'package:flutter/material.dart';

class CalendarConverter extends StatefulWidget {
  static const page = "/calendar_converter";

  const CalendarConverter({super.key});

  @override
  State<CalendarConverter> createState() => _CalendarConverterState();
}

class _CalendarConverterState extends State<CalendarConverter> {
  late Future<CalendarExecuteState> state;
  late DateTime input;

  final CalendarWrapper _api = CalendarWrapper();
  @override
  void initState() {
    super.initState();
    input = DateTime.now();
    state = _api.setCalendar(
      null,
      input.year,
      input.month,
      input.day,
      CalendarSystemFromDart.gregorian,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () async {
            input = await showDatePicker(
                  context: context,
                  firstDate: DateTime(-2583),
                  lastDate: DateTime(2300),
                ) ??
                input;
            if (context.mounted) {
              setState(() {
                state = _api.setCalendar(
                  null,
                  input.year,
                  input.month,
                  input.day,
                  CalendarSystemFromDart.gregorian,
                );
              });
            }
          },
          label: Text("Select date"),
        ),
        FutureBuilder(
          future: state,
          builder: (context, snapshot) {
            Widget toUse;
            if (snapshot.hasData) {
              List<Widget> listToShow = [
                Text(
                    "Date sent: ${input.year} - ${input.month} - ${input.day}"),
                Text("Successful: ${snapshot.data!.isSuccess}"),
                if (!snapshot.data!.isSuccess)
                  Text("Message to show: ${snapshot.data!.message}"),
              ];

              for (var i in snapshot.data!.data.keys) {
                List<int> parsedData = List<int>.generate(
                  snapshot.data!.data[i]!.length,
                  (j) => int.parse(snapshot.data!.data[i]![j]),
                );

                switch (i) {
                  case CalendarSystemFromDart.gregorian:
                    listToShow.add(Text(
                      "Geogorian: ${parsedData[0]} - ${standardMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.milankovic:
                    listToShow.add(Text(
                      "Milankovic: ${parsedData[0]} - ${standardMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.julian:
                    listToShow.add(Text(
                      "Julian: ${parsedData[0]} - ${standardMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.islamic:
                    listToShow.add(Text(
                      "Islamic: ${parsedData[0]} - ${islamicMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.hebrew:
                    listToShow.add(Text(
                      "Hebrew: ${parsedData[0]} - ${hebrewMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.egyptian:
                    listToShow.add(Text(
                      "Egyptian: ${parsedData[0]} - ${parsedData[1]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.persian:
                    listToShow.add(Text(
                      "Persian: ${parsedData[0]} - ${persianMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.coptic:
                    listToShow.add(Text(
                      "Coptic: ${parsedData[0]} - ${copticMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.ethiopian:
                    listToShow.add(Text(
                      "Ethiopian: ${parsedData[0]} - ${ethiopianMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.indian:
                    listToShow.add(Text(
                      "Indian: ${parsedData[0]} - ${indianMonths[parsedData[1]]} - ${parsedData[2] + 1}",
                    ));
                    break;
                  case CalendarSystemFromDart.chinese:
                    listToShow.add(Text(
                      "Chinese: ${chineseElements[parsedData[0]]} - ${chineseAnimals[parsedData[1]]}年 - ${chineseMonths[parsedData[2]]} - ${parsedData[3] + 1}",
                    ));
                    break;
                }
              }
              toUse = Column(children: listToShow);
            } else {
              toUse = Text("Loading...");
            }
            return Center(child: toUse);
          },
        ),
      ],
    );
  }
}
