import 'package:hive/hive.dart';

part 'save_glucose_entry.g.dart';

@HiveType(typeId: 0)
enum MeasureUnit {
  @HiveField(0)
  mmol,

  @HiveField(1)
  mgdl,
}

@HiveType(typeId: 1)
class SaveGlucoseEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double value;

  @HiveField(2)
  MeasureUnit unit;

  @HiveField(3)
  String? notes;

  SaveGlucoseEntry({
    required this.date,
    required this.value,
    required this.unit,
    this.notes,
  });
}
