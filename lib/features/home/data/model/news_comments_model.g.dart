// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_comments_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsCommentModelAdapter extends TypeAdapter<NewsCommentModel> {
  @override
  final int typeId = 2;

  @override
  NewsCommentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsCommentModel(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      newsId: fields[2] as String?,
      parentCommentId: fields[3] as String?,
      isProfessor: fields[4] as int?,
      content: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      user: fields[8] as UserModel?,
      isExpanded: fields[10] as bool,
      children: (fields[9] as List?)?.cast<NewsCommentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, NewsCommentModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.newsId)
      ..writeByte(3)
      ..write(obj.parentCommentId)
      ..writeByte(4)
      ..write(obj.isProfessor)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.user)
      ..writeByte(9)
      ..write(obj.children)
      ..writeByte(10)
      ..write(obj.isExpanded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsCommentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 3;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      image: fields[1] as String?,
      name: fields[2] as String?,
      email: fields[3] as String?,
      userType: fields[4] as int?,
      accountStatus: fields[5] as int?,
      randomCode: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.userType)
      ..writeByte(5)
      ..write(obj.accountStatus)
      ..writeByte(6)
      ..write(obj.randomCode)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
