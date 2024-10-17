import 'package:hive/hive.dart';

part 'news_image.g.dart';

@HiveType(typeId: 1)
class NewsImage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String imageableType;

  @HiveField(3)
  final String imageableId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  NewsImage({
    required this.id,
    required this.imagePath,
    required this.imageableType,
    required this.imageableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsImage.fromJson(Map<String, dynamic> json) {
    return NewsImage(
      id: json['id'],
      imagePath: json['image_path'],
      imageableType: json['imageable_type'],
      imageableId: json['imageable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'imageable_type': imageableType,
      'imageable_id': imageableId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
