// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bt_search_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BTSearchResultAdapter extends TypeAdapter<BTSearchResult> {
  @override
  final int typeId = 2;

  @override
  BTSearchResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BTSearchResult(
      type: fields[0] as String,
      value: fields[1] as String,
      header: fields[2] as String,
      subheader1: fields[3] as String,
      subheader2: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BTSearchResult obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.header)
      ..writeByte(3)
      ..write(obj.subheader1)
      ..writeByte(4)
      ..write(obj.subheader2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BTSearchResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
