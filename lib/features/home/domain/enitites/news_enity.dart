import 'package:hive_flutter/adapters.dart';

import 'package:lms/features/home/domain/enitites/news_image.dart';
part 'news_enity.g.dart';

@HiveType(typeId: 0)
class NewsEnity {
  @HiveField(0)
  final String idN;
  @HiveField(1)
  final String userIdN;
  @HiveField(2)
  final String? fileN;
  @HiveField(3)
  final String textN;
  @HiveField(4)
  final DateTime createdAtN;
  @HiveField(5)
  final DateTime updatedAtN;
  @HiveField(6)
  final String? filenameN;
  @HiveField(7)
  final List<NewsImage> imagesN;

  NewsEnity(
      {required this.idN,
      required this.userIdN,
      required this.fileN,
      required this.textN,
      required this.createdAtN,
      required this.updatedAtN,
      required this.filenameN,
      required this.imagesN});

  factory NewsEnity.fromJson(Map<String, dynamic> json) {
    return NewsEnity(
      idN: json['id'],
      userIdN: json['user_id'],
      fileN: json['file'],
      textN: json['text'],
      createdAtN: DateTime.parse(json['created_at']),
      updatedAtN: DateTime.parse(json['updated_at']),
      filenameN: json['filename'],
      imagesN: (json['images'] as List<dynamic>)
          .map((image) => NewsImage.fromJson(image))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idN,
      'user_id': userIdN,
      'file': fileN,
      'text': textN,
      'created_at': createdAtN.toIso8601String(),
      'updated_at': updatedAtN.toIso8601String(),
      'filename': filenameN,
      'images': imagesN.map((image) => image.toJson()).toList(),
    };
  }
}
