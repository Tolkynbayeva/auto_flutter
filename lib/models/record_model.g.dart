// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<Record> {
  @override
  final int typeId = 1;

  @override
  Record read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record(
      car: fields[0] as Car,
      mileage: fields[1] as String,
      category: fields[2] as String,
      cost: fields[3] as String,
      note: fields[4] as String,
      comment: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.car)
      ..writeByte(1)
      ..write(obj.mileage)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
