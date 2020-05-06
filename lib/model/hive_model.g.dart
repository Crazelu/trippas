// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrippasAdapter extends TypeAdapter<Trippas> {
  @override
  Trippas read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trippas(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Trippas obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.departure)
      ..writeByte(1)
      ..write(obj.departureDate)
      ..writeByte(2)
      ..write(obj.departureTime)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.destinationDate)
      ..writeByte(5)
      ..write(obj.destinationTime)
      ..writeByte(6)
      ..write(obj.tripType);
  }

  @override
  int get typeId => 0;
}
