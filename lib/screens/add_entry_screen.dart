import 'package:d_app/models/save_glucose_entry.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/material.dart';

// enum MeasureUnit { mmol, mgdl }

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  MeasureUnit? _selectedUnit = MeasureUnit.mmol;
  final TextEditingController _glucoseController = TextEditingController();

  String _getUnitText(MeasureUnit? unit) {
    switch (unit) {
      case MeasureUnit.mmol:
        return 'ммоль/л';
      case MeasureUnit.mgdl:
        return 'мг/дл';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _glucoseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить информацию')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         cursorColor: Colors.lightGreenAccent,
              //         controller: _glucoseController,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           focusedBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: Colors.lightGreenAccent,
              //             ),
              //           ),
              //           floatingLabelStyle: TextStyle(
              //             color: Colors.lightGreenAccent,
              //           ),
              //           labelText: 'Уровень глюкозы',
              //           border: OutlineInputBorder(),
              //         ),
              //       ),
              //     ),

              //     const SizedBox(width: 20),

              //     DropdownMenu<MeasureUnit>(
              //       initialSelection: MeasureUnit.mmol,
              //       // controller: _glucoseController,
              //       // requestFocusOnTap: true,
              //       label: const Text('Еденицы измерения'),
              //       onSelected: (MeasureUnit? unit) {
              //         setState(() {
              //           _selectedUnit = unit;
              //         });
              //       },
              //       dropdownMenuEntries:
              //           MeasureUnit.values
              //               .map(
              //                 (unit) => DropdownMenuEntry<MeasureUnit>(
              //                   value: unit,
              //                   label: _getUnitText(unit),
              //                 ),
              //               )
              //               .toList(),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      cursorColor: Colors.lightGreenAccent,
                      controller: _glucoseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Colors.lightGreenAccent,
                        ),
                        label: Text(
                          'Уровень глюкозы',
                          style: TextStyle(fontFamily: 'LXGW'),
                        ),
                        hint: Text(
                          'Введите уровень глюкозы',
                          style: TextStyle(
                            fontFamily: 'LXGW',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontFamily: 'LXGW'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 1,
                    child: DropdownMenu<MeasureUnit>(
                      initialSelection: MeasureUnit.mmol,
                      // controller: _glucoseController,
                      // requestFocusOnTap: true,
                      label: const Text(
                        'Еденицы измерения',
                        style: TextStyle(fontFamily: 'LXGW'),
                      ),
                      onSelected: (MeasureUnit? unit) {
                        setState(() {
                          _selectedUnit = unit;
                        });
                      },
                      dropdownMenuEntries:
                          MeasureUnit.values
                              .map(
                                (unit) => DropdownMenuEntry<MeasureUnit>(
                                  value: unit,
                                  label: _getUnitText(unit),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GeneralTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_glucoseController.text.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // duration: Duration(milliseconds: 500),
                          content: Row(
                            children: [
                              Icon(Icons.error, color: Colors.black),
                              const SizedBox(width: 10),
                              const Text(
                                'Введите данные в поле!',
                                style: TextStyle(fontFamily: 'LXGW'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final value = double.tryParse(_glucoseController.text);
                    if (value == null) return;

                    double convertedValue =
                        _selectedUnit == MeasureUnit.mgdl ? value / 10 : value;

                    final newEntry = SaveGlucoseEntry(
                      date: DateTime.now(),
                      value: convertedValue,
                      unit: _selectedUnit!,
                    );

                    Navigator.pop(context, newEntry);
                  },
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(fontFamily: 'LXGW', color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
