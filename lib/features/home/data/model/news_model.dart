import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/enitites/news_image.dart';

class NewsModel extends NewsEnity {
  final String id;
  final String userId;
  final String? file;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? filename;
  final List<NewsImage> images;

  NewsModel({
    required this.id,
    required this.userId,
    this.file,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    this.filename,
    required this.images,
  }) : super(
            idN: id,
            userIdN: userId,
            fileN: file,
            textN: text,
            createdAtN: createdAt,
            updatedAtN: updatedAt,
            filenameN: filename,
            imagesN: images);

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      userId: json['user_id'],
      file: json['file'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      filename: json['filename'],
      images: (json['images'] as List<dynamic>)
          .map((image) => NewsImage.fromJson(image))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file': file,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'filename': filename,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}
