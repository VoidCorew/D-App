import 'package:d_app/models/save_glucose_entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GlucoseProvider extends ChangeNotifier {
  List<SaveGlucoseEntry> _entries = [];
  List<SaveGlucoseEntry> get entries => _entries;

  List<SaveGlucoseEntry> _trashed = [];
  List<SaveGlucoseEntry> get trashed => _trashed;

  final box = Hive.box<SaveGlucoseEntry>('glucoseBox');
  final trashedBox = Hive.box<SaveGlucoseEntry>('trashedGlucoseBox');

  GlucoseProvider() {
    loadEntries();
    _loadDeleteEntries();
  }

  void loadEntries() {
    // final box = Hive.box<SaveGlucoseEntry>('glucoseBox');
    _entries = box.values.toList();
    notifyListeners();
  }

  void addEntry(SaveGlucoseEntry entry) {
    // final box = Hive.box<SaveGlucoseEntry>('glucoseBox');
    box.add(entry);
    _entries.add(entry);
    notifyListeners();
  }

  void _loadDeleteEntries() {
    _trashed = trashedBox.values.toList();
    notifyListeners();
  }

  void deleteEntry(SaveGlucoseEntry entry) async {
    final key = box.keyAt(_entries.indexOf(entry));
    await box.delete(key);
    _entries.remove(entry);

    // final trashedKey = await trashedBox.add(entry);
    await trashedBox.add(entry);
    _trashed.add(entry);

    notifyListeners();
  }

  void restoreEntry(SaveGlucoseEntry entry) async {
    final key = trashedBox.keyAt(_trashed.indexOf(entry));
    await trashedBox.delete(key);
    _trashed.remove(entry);

    // final newKey = await box.add(entry);
    await box.add(entry);
    _entries.add(entry);

    notifyListeners();
  }

  void deleteForever(SaveGlucoseEntry entry) async {
    final key = trashedBox.keyAt(_trashed.indexOf(entry));
    await trashedBox.delete(key);
    _trashed.remove(entry);
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

  String unitText(SaveGlucoseEntry entry) {
    switch (entry.unit) {
      case MeasureUnit.mmol:
        return 'ммоль/г';
      case MeasureUnit.mgdl:
        return 'мг/дл';
    }
  }
}
