import 'package:d_app/providers/glucose_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GlucoseEntry {
  final DateTime date;
  final double value;

  GlucoseEntry({required this.date, required this.value});
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();

  final List<GlucoseEntry> glucoseData = [];

  // выбор дня
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  List<GlucoseEntry> getEntriesForDay(DateTime day) {
    return glucoseData.where((entry) {
      return entry.date.year == day.year &&
          entry.date.month == day.month &&
          entry.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEntries = getEntriesForDay(today);

    final glucoseProvider = context.watch<GlucoseProvider>();
    final entries = glucoseProvider.getEntriesForDay(today);

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      //     child: AppBar(
      //       backgroundColor: Colors.transparent.withValues(alpha: 0.3),
      //     ),
      //   ),
      // ),
      appBar: AppBar(title: Text('Календарь'), elevation: 10),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Selected Day: ${today.toString().split(" ")[0]}'),
            Container(
              child: TableCalendar(
                // locale: "ru_RU",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2019, 10, 18),
                lastDay: DateTime.utc(2030, 4, 20),
                pageAnimationDuration: Duration(milliseconds: 400),
                onDaySelected: _onDaySelected,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Записи за ${DateFormat('yyyy-MM-dd').format(today)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child:
                  selectedEntries.isEmpty
                      ? const Center(child: Text('Нет данных за этот день'))
                      : ListView.builder(
                        itemCount: selectedEntries.length,
                        itemBuilder: (context, index) {
                          final entry = selectedEntries[index];
                          return ListTile(
                            title: Text(
                              '${entry.value.toStringAsFixed(1)} ммоль/г',
                            ),
                            subtitle: Text(
                              DateFormat('HH:mm').format(entry.date),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
