// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_glucose_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveGlucoseEntryAdapter extends TypeAdapter<SaveGlucoseEntry> {
  @override
  final int typeId = 1;

  @override
  SaveGlucoseEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveGlucoseEntry(
      date: fields[0] as DateTime,
      value: fields[1] as double,
      unit: fields[2] as MeasureUnit,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SaveGlucoseEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveGlucoseEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasureUnitAdapter extends TypeAdapter<MeasureUnit> {
  @override
  final int typeId = 0;

  @override
  MeasureUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeasureUnit.mmol;
      case 1:
        return MeasureUnit.mgdl;
      default:
        return MeasureUnit.mmol;
    }
  }

  @override
  void write(BinaryWriter writer, MeasureUnit obj) {
    switch (obj) {
      case MeasureUnit.mmol:
        writer.writeByte(0);
        break;
      case MeasureUnit.mgdl:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
