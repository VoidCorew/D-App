import 'dart:math';

import 'package:d_app/models/save_glucose_entry.dart';
import 'package:d_app/providers/glucose_provider.dart';
import 'package:d_app/screens/trash_screen.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  final List<SaveGlucoseEntry> glucoseData = [];

  // выбор дня
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  List<SaveGlucoseEntry> getEntriesForDay(DateTime day) {
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
      appBar: AppBar(
        title: Text('Календарь'),
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => TrashScreen()),
                ),
            icon: Icon(Icons.delete, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Выбранный день: ${today.toString().split(" ")[0]}',
              style: TextStyle(fontFamily: 'Jura', fontSize: 18),
            ),
            Container(
              child: TableCalendar(
                // locale: "ru_RU",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2019, 10, 18),
                lastDay: DateTime.utc(2030, 4, 20),
                pageAnimationDuration: Duration(milliseconds: 400),
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  outsideTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  todayTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedTextStyle: TextStyle(
                    fontFamily: 'LXGW',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Записи за ${DateFormat('yyyy-MM-dd').format(today)}',
              style: GeneralTheme.titleStyle,
            ),

            Expanded(
              child:
                  entries.isEmpty
                      ? const Center(
                        child: Text(
                          'Нет данных за этот день',
                          style: TextStyle(fontFamily: 'Jura'),
                        ),
                      )
                      : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    glucoseProvider.deleteEntry(entry);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Запись перемещена в корзину',
                                          style: TextStyle(fontFamily: 'LXGW'),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                '${entry.value.toStringAsFixed(1)} ${glucoseProvider.unitText(entry)}',
                                style: GeneralTheme.listTileTitleStyle,
                              ),
                              subtitle: Text(
                                DateFormat('HH:mm').format(entry.date),
                                style: GeneralTheme.listTileSubtitleStyle,
                              ),
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
