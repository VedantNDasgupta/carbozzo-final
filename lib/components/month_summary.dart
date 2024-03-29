import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;

  const MonthlySummary({
    Key? key,
    required this.datasets,
    required startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfCurrentMonth = DateTime.now().subtract(
      Duration(days: DateTime.now().day - 1),
    );

    return Container(
      padding: const EdgeInsets.only(top: 3, bottom: 3, left: 20),
      child: HeatMap(
        startDate: firstDayOfCurrentMonth,
        endDate: firstDayOfCurrentMonth.add(Duration(days: 28)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.red,
        textColor: Colors.black,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(20, 2, 179, 8),
          2: Color.fromARGB(40, 2, 179, 8),
          3: Color.fromARGB(60, 2, 179, 8),
          4: Color.fromARGB(80, 2, 179, 8),
          5: Color.fromARGB(100, 2, 179, 8),
          6: Color.fromARGB(120, 2, 179, 8),
          7: Color.fromARGB(150, 2, 179, 8),
          8: Color.fromARGB(180, 2, 179, 8),
          9: Color.fromARGB(220, 2, 179, 8),
          10: Color.fromARGB(255, 2, 179, 8),
        },
      ),
    );
  }
}
