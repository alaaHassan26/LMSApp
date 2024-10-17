// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_enity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsEnityAdapter extends TypeAdapter<NewsEnity> {
  @override
  final int typeId = 0;

  @override
  NewsEnity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsEnity(
      idN: fields[0] as String,
      userIdN: fields[1] as String,
      fileN: fields[2] as String?,
      textN: fields[3] as String,
      createdAtN: fields[4] as DateTime,
      updatedAtN: fields[5] as DateTime,
      filenameN: fields[6] as String?,
      imagesN: (fields[7] as List).cast<NewsImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, NewsEnity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idN)
      ..writeByte(1)
      ..write(obj.userIdN)
      ..writeByte(2)
      ..write(obj.fileN)
      ..writeByte(3)
      ..write(obj.textN)
      ..writeByte(4)
      ..write(obj.createdAtN)
      ..writeByte(5)
      ..write(obj.updatedAtN)
      ..writeByte(6)
      ..write(obj.filenameN)
      ..writeByte(7)
      ..write(obj.imagesN);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsEnityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
