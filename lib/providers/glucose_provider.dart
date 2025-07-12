import 'package:d_app/models/save_glucose_entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GlucoseProvider extends ChangeNotifier {
  List<SaveGlucoseEntry> _entries = [];

  List<SaveGlucoseEntry> get entries => _entries;

  GlucoseProvider() {
    loadEntries();
  }

  void loadEntries() {
    final box = Hive.box<SaveGlucoseEntry>('glucoseBox');
    _entries = box.values.toList();
    notifyListeners();
  }

  void addEntry(SaveGlucoseEntry entry) {
    final box = Hive.box<SaveGlucoseEntry>('glucoseBox');
    box.add(entry);
    _entries.add(entry);
    notifyListeners();
  }

  List<SaveGlucoseEntry> getEntriesForDay(DateTime day) {
    return _entries.where((entry) {
        return entry.date.year == day.year &&
            entry.date.month == day.month &&
            entry.date.day == day.day;
      }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
