// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trunk_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrunkItemAdapter extends TypeAdapter<TrunkItem> {
  @override
  final int typeId = 2;

  @override
  TrunkItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrunkItem(
      car: fields[0] as String,
      name: fields[1] as String,
      comment: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrunkItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.car)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrunkItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
