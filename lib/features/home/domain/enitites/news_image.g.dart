// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsImageAdapter extends TypeAdapter<NewsImage> {
  @override
  final int typeId = 1;

  @override
  NewsImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsImage(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      imageableType: fields[2] as String,
      imageableId: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NewsImage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.imageableType)
      ..writeByte(3)
      ..write(obj.imageableId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
