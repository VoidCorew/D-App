import 'package:d_app/models/save_glucose_entry.dart';
import 'package:d_app/providers/glucose_provider.dart';
import 'package:d_app/screens/add_entry_screen.dart';
import 'package:d_app/screens/diabetes_info_screen.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // List<GlucoseEntry> glucoseData = [];

  List<String> radioOptions = ['1 Тип', '2 Тип', 'Гестационный'];
  String _selectedOption = '1 Тип';
  String? _currentDiabetesType;
  // int? _selectedValue;

  // List<GlucoseEntry> getTodayEntries() {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   return glucoseData.where((entry) {
  //       final entryDate = DateTime(
  //         entry.date.year,
  //         entry.date.month,
  //         entry.date.day,
  //       );
  //       return entryDate == today;
  //     }).toList()
  //     ..sort((a, b) => b.date.compareTo(a.date));
  // }

  @override
  Widget build(BuildContext context) {
    final glucoseProvider = context.watch<GlucoseProvider>();
    final glucoseData = glucoseProvider.getEntriesForDay(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(color: Colors.black),
          glucoseData.isNotEmpty
              ? 'Текущий уровень: ${glucoseData.last.value.toStringAsFixed(1)}'
              : 'Нет данных',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.black),
          ),
          // IconButton(
          //   onPressed: () {
          //     final size = MediaQuery.of(context).size;
          //     debugPrint("Ширина: ${size.width}");
          //     debugPrint("Высота: ${size.height}");
          //   },
          //   icon: Icon(Icons.abc, color: Colors.black),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                const Text('Ваш тип', style: GeneralTheme.titleStyle),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var option in radioOptions)
                      RadioListTile(
                        activeColor: GeneralTheme.primary,
                        title: Text(option, style: GeneralTheme.radioTextStyle),
                        value: option,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        generalButton(() {
                          setState(() {
                            _currentDiabetesType = _selectedOption;
                            debugPrint(_currentDiabetesType);
                          });
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Сохранено! Вы также можете изменить свой вариант в настройках',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'LXGW'),
                              ),
                              // content: Row(
                              //   children: [
                              //     Icon(Icons.check_circle_rounded),

                              //     const SizedBox(width: 10),

                              //     Expanded(
                              //       child: const Text(
                              //         'Сохранено! Вы также можете изменить свой вариант в настройках',
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          );
                        }, 'Сохранить вариант'),

                        const SizedBox(width: 10),

                        generalButton(() {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DiabetesInfoScreen(),
                            ),
                          );
                        }, 'Информация'),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            Text('Информация за сегодня', style: GeneralTheme.titleStyle),

            Expanded(
              child: Builder(
                builder: (context) {
                  // final todayEntries = getTodayEntries();
                  final todayEntries = glucoseData;
                  if (todayEntries.isEmpty) {
                    return Center(
                      child: const Text(
                        'У вас пока нет данных за сегодня',
                        style: TextStyle(fontFamily: 'Jura'),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final entry = todayEntries[index];
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
                      // separatorBuilder: (context, index) => Divider(),
                      itemCount: todayEntries.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GeneralTheme.primary,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => AddEntryScreen()),
          );

          if (result != null && result is SaveGlucoseEntry) {
            // setState(() {
            //   glucoseData.add(result);
            // });
            context.read<GlucoseProvider>().addEntry(result);
          }
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  ElevatedButton generalButton(Function()? onPressed, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: GeneralTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontFamily: 'LXGW', color: Colors.black),
      ),
    );
  }
}
